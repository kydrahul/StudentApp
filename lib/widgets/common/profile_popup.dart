import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class ProfilePopup extends StatelessWidget {
  final VoidCallback onClose;

  const ProfilePopup({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Backdrop
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),
        ),
        // Popup
        Positioned(
          top: 80,
          right: 24,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 288, // w-72
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(color: AppColors.gray100),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close Button
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: onClose,
                      child: const Icon(LucideIcons.xCircle, size: 20, color: AppColors.gray400),
                    ),
                  ),
                  
                  // Profile Image
                  Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF60A5FA), Color(0xFFC084FC)], // blue-400 to purple-400
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
                  const SizedBox(height: 12),
                  
                  // Name & Branch
                  Text("Alex Johnson", style: AppTextStyles.h3),
                  Text("Computer Science", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray500)),
                  const SizedBox(height: 16),
                  
                  // Details Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.gray50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow("Roll No", "2023-CS-104"),
                        const SizedBox(height: 12),
                        _buildDetailRow("Year", "3rd Year"),
                        const SizedBox(height: 12),
                        _buildDetailRow("Pass Out", "2026"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label.toUpperCase(), style: AppTextStyles.label),
        Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray700)),
      ],
    );
  }
}
