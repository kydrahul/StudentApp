import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  Map<String, dynamic>? _profileData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final dashboard = await _apiService.getDashboard();
      if (mounted) {
        setState(() {
          _profileData = dashboard['student'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load profile: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.alertCircle,
                              size: 48, color: AppColors.red500),
                          const SizedBox(height: 16),
                          Text(_errorMessage!, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchProfile,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
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
                                child: const Icon(LucideIcons.chevronLeft,
                                    size: 20, color: AppColors.gray600),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text("My Account",
                                style: AppTextStyles.h2
                                    .copyWith(fontWeight: FontWeight.bold)),
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
                                  "https://api.dicebear.com/7.x/avataaars/svg?seed=${_profileData?['name'] ?? 'User'}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _profileData?['name'] ?? 'N/A',
                            style: AppTextStyles.h1
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _profileData?['department'] ??
                                _profileData?['branch'] ??
                                'N/A',
                            style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.gray500,
                                fontWeight: FontWeight.w500),
                          ),
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
                              _buildDetailRow("Roll Number",
                                  _profileData?['rollNo'] ?? 'N/A'),
                              _buildDivider(),
                              _buildDetailRow(
                                  "Branch",
                                  _profileData?['department'] ??
                                      _profileData?['branch'] ??
                                      'N/A'),
                              _buildDivider(),
                              _buildDetailRow(
                                  "Year",
                                  _profileData?['year'] ??
                                      _profileData?['passingYear'] ??
                                      'N/A'),
                              _buildDivider(),
                              _buildDetailRow("Email",
                                  _authService.currentUser?.email ?? 'N/A'),
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
          Text(label,
              style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray500, fontWeight: FontWeight.w500)),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray800, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: AppColors.gray50);
  }
}
