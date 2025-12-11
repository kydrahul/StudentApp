import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Artificial delay for splash effect
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final user = _authService.currentUser;

    if (user == null) {
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    // User is authenticated, check if profile exists
    try {
      // Pass true to bypass cache and verify real DB existence
      await _apiService.getProfile(checkProfileExists: true);
      // Profile exists, go to home
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('Profile check failed: $e');

      if (e.toString().contains('Profile not found')) {
        if (mounted) Navigator.pushReplacementNamed(context, '/profile-setup');
      } else {
        // Show error dialog for other errors (e.g. 500, Network)
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Connection Error'),
              content: Text(
                  'Could not verify profile. Error: ${e.toString().replaceAll("Exception:", "")}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    _checkAuthAndNavigate(); // Retry
                  },
                  child: const Text('Retry'),
                ),
                TextButton(
                  onPressed: () {
                    _authService.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/logo.png',
              width: 150,
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.school,
                    size: 100, color: AppColors.blue600);
              },
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text(
              'Verifying Profile...',
              style: TextStyle(
                color: AppColors.gray600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
