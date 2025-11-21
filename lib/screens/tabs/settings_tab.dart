import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../account_screen.dart';
import '../../services/auth_service.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      children: [
        Text("Settings",
            style: AppTextStyles.h1.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gray100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSettingItem(
                context,
                icon: LucideIcons.user,
                iconColor: AppColors.blue600,
                iconBg: AppColors.blue50,
                label: "Account",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountScreen()),
                  );
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                context,
                icon: LucideIcons.clipboardList,
                iconColor: AppColors.green600,
                iconBg: AppColors.green50,
                label: "Attendance History",
                onTap: () {
                  Navigator.pushNamed(context, '/attendance-history');
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                context,
                icon: LucideIcons.fileText,
                iconColor: AppColors.gray600,
                iconBg: AppColors.gray50,
                label: "Terms & Conditions",
                onTap: () {},
              ),
              _buildDivider(),
              _buildSettingItem(
                context,
                icon: LucideIcons.shield,
                iconColor: AppColors.gray600,
                iconBg: AppColors.gray50,
                label: "Privacy Policy",
                onTap: () {},
              ),
              _buildDivider(),
              _buildSettingItem(
                context,
                icon: LucideIcons.info,
                iconColor: AppColors.gray600,
                iconBg: AppColors.gray50,
                label: "About",
                onTap: () {},
              ),
              _buildDivider(),
              _buildSettingItem(
                context,
                icon: LucideIcons.logOut,
                iconColor: AppColors.red500,
                iconBg: AppColors.red50,
                label: "Logout",
                labelColor: AppColors.red500,
                onTap: () async {
                  await AuthService().signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Center(
            child: Text("Version 1.0.0",
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.gray400))),
      ],
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    Color? labelColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: labelColor ?? AppColors.gray700,
                  ),
                ),
              ],
            ),
            const Icon(LucideIcons.chevronRight,
                size: 16, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: AppColors.gray50);
  }
}
