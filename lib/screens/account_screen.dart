import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.gray200),
                      ),
                      child: const Icon(LucideIcons.chevronLeft, size: 20, color: AppColors.gray600),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text("My Account", style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Profile Info
            Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF60A5FA), Color(0xFFC084FC)],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: ClipOval(
                      child: Image.network(
                        "https://api.dicebear.com/7.x/avataaars/svg?seed=Felix",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text("Alex Johnson", style: AppTextStyles.h1.copyWith(fontWeight: FontWeight.bold)),
                Text("Computer Science", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray500, fontWeight: FontWeight.w500)),
              ],
            ),

            const SizedBox(height: 32),

            // Details List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.gray100),
                ),
                child: Column(
                  children: [
                    _buildDetailRow("Roll Number", "2023-CS-104"),
                    _buildDivider(),
                    _buildDetailRow("Branch", "Computer Science"),
                    _buildDivider(),
                    _buildDetailRow("Passing Year", "2026"),
                    _buildDivider(),
                    _buildDetailRow("Email", "alex.j@college.edu"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray500, fontWeight: FontWeight.w500)),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray800, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: AppColors.gray50);
  }
}
