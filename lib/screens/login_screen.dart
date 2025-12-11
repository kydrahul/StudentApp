import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userCredential = await _authService.signInWithGoogle();

      if (userCredential == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Validate email domain
      final email = userCredential.user?.email ?? '';
      if (!email.endsWith('@iiitnr.edu.in')) {
        setState(() {
          _errorMessage =
              'Only IIITNR students can access this app.\nPlease use your @iiitnr.edu.in email.';
          _isLoading = false;
        });
        await _authService.signOut();
        return;
      }

      // Check if profile exists (bypass cache to verify real DB state)
      try {
        await _apiService.getProfile(checkProfileExists: true);
        // Profile exists, navigate to home
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        if (e.toString().contains('Profile not found')) {
          // Profile doesn't exist, navigate to profile setup
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/profile-setup');
          }
        } else {
          // Other error (e.g. 500), show error message
          setState(() {
            _errorMessage =
                'Login Error: ${e.toString().replaceAll("Exception:", "")}';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sign in: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Box
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/home-logo.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.school,
                  size: 40,
                  color: AppColors.blue600,
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Error Message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),

            // Login Button
            ElevatedButton(
              onPressed: _isLoading ? null : _handleGoogleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.gray700,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.gray200),
                ),
                minimumSize: const Size(double.infinity, 56),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.g_mobiledata,
                            size: 32, color: Colors.blue),
                        const SizedBox(width: 12),
                        Text(
                          'Login via Institute Email',
                          style: AppTextStyles.h3,
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 12),

            // Email domain hint
            Text(
              '(email ends with @iiitnr.edu.in)',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.gray500,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Disclaimer
            Text(
              'By logging in, you agree to the Terms of Service and '
              'Privacy Policy of your institution.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
