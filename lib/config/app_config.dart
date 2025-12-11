class AppConfig {
  static const String apiBaseUrl =
      'https://iiitnrattendence-backend.onrender.com';
  // Use local backend for testing device binding
  // static const String apiBaseUrl = 'http://192.168.137.1:4000';
  static const String apiVersion = '/api';

  static String get baseUrl => '$apiBaseUrl$apiVersion';
}
