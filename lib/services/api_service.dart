import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'auth_service.dart';
import 'device_service.dart';

class ApiService {
  final AuthService _authService = AuthService();
  final DeviceService _deviceService = DeviceService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    final deviceId = await _deviceService.getDeviceId();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
      'x-device-id': deviceId,
    };
  }

  // Get Student Profile
  Future<Map<String, dynamic>> getProfile(
      {bool checkProfileExists = false}) async {
    try {
      final headers = await _getHeaders();
      // Add nocache query param if checking for profile existence
      final url = checkProfileExists
          ? '${AppConfig.baseUrl}/student/profile?nocache=true'
          : '${AppConfig.baseUrl}/student/profile';

      final response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['student'];
      } else {
        if (response.statusCode == 404) {
          throw Exception('Profile not found');
        } else {
          // Propagate error message for UI to show (and NOT redirect to setup)
          final errorData = json.decode(response.body);
          throw Exception(
              'Server Error ${response.statusCode}: ${errorData['details'] ?? errorData['error'] ?? response.body}');
        }
      }
    } catch (e) {
      print('Error in getProfile: $e');
      rethrow;
    }
  }

  // Verify Location (Geofence check)
  Future<Map<String, dynamic>> verifyLocation({
    required double latitude,
    required double longitude,
    double? accuracy,
  }) async {
    final response = await http
        .post(
          Uri.parse('${AppConfig.baseUrl}/student/verify-location'),
          headers: await _getHeaders(),
          body: jsonEncode({
            'latitude': latitude,
            'longitude': longitude,
            'accuracy': accuracy,
          }),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 403) {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Location verification failed');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Failed to verify location');
    }
  }

  // Create/Update Student Profile
  Future<Map<String, dynamic>> createProfile({
    required String name,
    required int rollNo,
    required String department,
    required int passingYear,
  }) async {
    final deviceId = await _deviceService.getDeviceId();

    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/student/profile'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'name': name,
        'rollNo': rollNo,
        'department': department,
        'passingYear': passingYear,
        'deviceId': deviceId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 403) {
      final error = jsonDecode(response.body);
      throw DeviceMismatchException(error['message'] ?? 'Device mismatch');
    } else {
      throw Exception('Failed to create profile: ${response.body}');
    }
  }

  // Get Student Dashboard
  Future<Map<String, dynamic>> getDashboard() async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/student/dashboard'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch dashboard: ${response.body}');
    }
  }

  // Scan QR Code
  Future<Map<String, dynamic>> scanQR({
    required String qrData,
    required double latitude,
    required double longitude,
    double? accuracy,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/student/scan-qr'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'qrData': qrData,
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Failed to mark attendance');
    }
  }

  // Join Course
  Future<Map<String, dynamic>> joinCourse(String joinCode) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/student/join-course'),
      headers: await _getHeaders(),
      body: jsonEncode({'joinCode': joinCode}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Failed to join course');
    }
  }

  // Get Enrolled Courses
  Future<List<dynamic>> getCourses() async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/student/courses'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['courses'] ?? [];
    } else {
      throw Exception('Failed to fetch courses');
    }
  }

  // Get Timetable
  Future<Map<String, dynamic>> getTimetable() async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/student/timetable'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['timetable'] ?? {};
    } else {
      throw Exception('Failed to fetch timetable');
    }
  }

  // Get Attendance History
  Future<List<dynamic>> getAttendanceHistory({String? courseId}) async {
    var url = '${AppConfig.baseUrl}/student/attendance-history';
    if (courseId != null) {
      url += '?courseId=$courseId';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['attendanceRecords'] ?? [];
    } else {
      throw Exception('Failed to fetch attendance history');
    }
  }
}

// Custom exception for device mismatch
class DeviceMismatchException implements Exception {
  final String message;
  DeviceMismatchException(this.message);

  @override
  String toString() => message;
}
