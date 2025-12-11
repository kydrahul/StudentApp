import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_options.dart';
import 'constants/colors.dart';
import 'screens/login_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/qr_scanner_screen.dart';
import 'screens/attendance_history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/not_found_screen.dart';
import 'services/auth_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  // Check for logged in user (Logic moved to SplashScreen)
  // final authService = AuthService();
  // final isLoggedIn = authService.currentUser != null;

  runApp(const StudentApp(initialRoute: '/'));
}

class StudentApp extends StatelessWidget {
  final String initialRoute;

  const StudentApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IIITNR Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.blue600,
          primary: AppColors.blue600,
          surface: AppColors.background,
        ),
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/profile-setup': (context) => const ProfileSetupScreen(),
        '/qr-scanner': (context) => const QRScannerScreen(),
        '/attendance-history': (context) => const AttendanceHistoryScreen(),
        '/home': (context) => const HomeScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const NotFoundScreen(),
        );
      },
    );
  }
}
