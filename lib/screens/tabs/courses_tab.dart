import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../data/mock_data.dart';
import '../../widgets/cards/course_card.dart';
import '../course_detail_screen.dart';

class CoursesTab extends StatefulWidget {
  const CoursesTab({super.key});

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  bool showJoinInput = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("My Courses", style: AppTextStyles.h1.copyWith(fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
                setState(() {
                  showJoinInput = !showJoinInput;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: showJoinInput ? AppColors.gray200 : AppColors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  showJoinInput ? LucideIcons.x : LucideIcons.plus,
                  color: showJoinInput ? AppColors.gray800 : AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),

        // Join Input
        if (showJoinInput)
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.gray200),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter class code to join...",
                        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray400),
                        prefixIcon: const Icon(LucideIcons.search, size: 16, color: AppColors.gray400),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue600,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text("Join"),
                ),
              ],
            ),
          ),

        // Enrolled List
        Text("ENROLLED", style: AppTextStyles.label.copyWith(fontSize: 12)),
        const SizedBox(height: 12),
        
        ...mockEnrolledCourses.map((course) => CourseCard(
          course: course,
          onClick: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailScreen(course: course),
              ),
            );
          },
        )),
      ],
    );
  }
}
