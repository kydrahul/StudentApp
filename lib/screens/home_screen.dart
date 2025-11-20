import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants/colors.dart';
import '../widgets/common/custom_header.dart';
import '../widgets/common/profile_popup.dart';
import 'tabs/home_tab.dart';
import 'tabs/courses_tab.dart';
import 'tabs/settings_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isProfileOpen = false;

  final List<Widget> _tabs = [
    const HomeTab(),
    const CoursesTab(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header only on Home Tab
                if (_currentIndex == 0)
                  CustomHeader(
                    onProfileClick: () {
                      setState(() {
                        _isProfileOpen = !_isProfileOpen;
                      });
                    },
                  ),
                
                Expanded(
                  child: _tabs[_currentIndex],
                ),
              ],
            ),
          ),

          // Profile Popup Overlay
          if (_isProfileOpen)
            ProfilePopup(
              onClose: () {
                setState(() {
                  _isProfileOpen = false;
                });
              },
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, LucideIcons.home, "Home"),
                _buildNavItem(1, LucideIcons.bookOpen, "Courses"),
                _buildNavItem(2, LucideIcons.settings, "Settings"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.black : AppColors.gray400,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.black : AppColors.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
