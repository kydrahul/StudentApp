import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'auth_service.dart';

class ApiService {
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  // Get Student Profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .get(
            Uri.parse('${AppConfig.baseUrl}/student/profile'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['student'] ?? {};
      } else if (response.statusCode == 404) {
        throw Exception(
            'Profile not found. Please complete your profile setup.');
      } else {
        throw Exception('Failed to fetch profile: ${response.body}');
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
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/student/profile'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'name': name,
        'rollNo': rollNo,
        'department': department,
        'passingYear': passingYear,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
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
