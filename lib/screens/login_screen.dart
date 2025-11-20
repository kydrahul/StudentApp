import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              width: 96,
              height: 96,
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
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                "assets/logo.png",
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.school,
                    size: 40,
                    color: AppColors.blue600),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              "DSPM IIITNR ATTENDANCE",
              style: AppTextStyles.header.copyWith(
                color: AppColors.blue600,
                fontSize: 14,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 48),

            // Login Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Icon SVG replacement (simple colored text/icon for now)
                  const Icon(Icons.g_mobiledata, size: 32, color: Colors.blue),
                  const SizedBox(width: 12),
                  Text(
                    "Login via Institute Email",
                    style: AppTextStyles.h3.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Text(
              "By logging in, you agree to the Terms of Service and Privacy Policy of your institution.",
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.gray400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
