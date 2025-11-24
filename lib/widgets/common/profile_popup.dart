import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class ProfilePopup extends StatelessWidget {
  final VoidCallback onClose;
  final Map<String, dynamic>? profileData;

  const ProfilePopup({
    super.key,
    required this.onClose,
    this.profileData,
  });

  @override
  Widget build(BuildContext context) {
    final name = profileData?['name'] ?? 'Unknown User';
    final department = profileData?['department'] ?? 'N/A';
    final rollNo = profileData?['rollNo']?.toString() ?? 'N/A';
    final email = profileData?['email'] ?? 'N/A';
    final passingYear = profileData?['passingYear']?.toString() ?? 'N/A';
    final photoUrl = profileData?['photoUrl'];

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
              width: 288,
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
                      child: const Icon(LucideIcons.xCircle,
                          size: 20, color: AppColors.gray400),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Profile Image from Google
                  Container(
                    width: 80,
                    height: 80,
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
                        child: photoUrl != null
                            ? Image.network(
                                photoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.person,
                                        size: 40, color: AppColors.gray400),
                              )
                            : const Icon(Icons.person,
                                size: 40, color: AppColors.gray400),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name & Branch
                  Text(name,
                      style: AppTextStyles.h3, textAlign: TextAlign.center),
                  Text(department,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.gray500)),
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
                        _buildDetailRow("Roll No", rollNo),
                        const SizedBox(height: 12),
                        _buildDetailRow("Email", email),
                        const SizedBox(height: 12),
                        _buildDetailRow("Pass Out", passingYear),
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
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray700),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
