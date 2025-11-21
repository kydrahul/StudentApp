class AppConfig {
  static const String apiBaseUrl =
      'https://iiitnrattendence-backend.onrender.com';
  static const String apiVersion = '/api';

  static String get baseUrl => '$apiBaseUrl$apiVersion';
}
