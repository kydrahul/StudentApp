import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../services/api_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final _nameController = TextEditingController();
  final _rollNoController = TextEditingController();
  final _departmentController = TextEditingController();
  final _yearController = TextEditingController();
  final _batchController = TextEditingController();
  final _semesterController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _apiService.createProfile(
        name: _nameController.text.trim(),
        rollNo: _rollNoController.text.trim(),
        department: _departmentController.text.trim(),
        year: _yearController.text.trim(),
        batch: _batchController.text.trim(),
        semester: _semesterController.text.trim(),
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Student Information', style: AppTextStyles.h2),
              const SizedBox(height: 24),
              _buildTextField('Full Name', _nameController, required: true),
              _buildTextField('Roll Number', _rollNoController, required: true),
              _buildTextField('Department', _departmentController),
              _buildTextField('Year', _yearController),
              _buildTextField('Batch', _batchController),
              _buildTextField('Semester', _semesterController),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue600,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: AppColors.white,
        ),
        validator: required
            ? (value) => value?.isEmpty ?? true ? 'Required' : null
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rollNoController.dispose();
    _departmentController.dispose();
    _yearController.dispose();
    _batchController.dispose();
    _semesterController.dispose();
    super.dispose();
  }
}
