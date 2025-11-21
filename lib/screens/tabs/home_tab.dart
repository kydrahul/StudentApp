import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/data_models.dart';
import '../../data/mock_data.dart';
import '../../widgets/common/search_bar.dart';
import '../../widgets/cards/class_item_card.dart';
import '../../widgets/cards/idle_item_card.dart';

import '../weekly_timetable_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // ... existing state ...
  String locationStatus = 'neutral'; // neutral, verifying, success, error
  String? lastVerified;
  bool canScan = false;
  int currentDayIndex = 2; // Wednesday
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  void _showScanner() {
    Navigator.pushNamed(context, '/qr-scanner');
  }

  void _showTimetable() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WeeklyTimetableScreen(),
      ),
    );
  }

  void _handleVerifyLocation() {
    setState(() {
      locationStatus = 'verifying';
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          locationStatus = 'success';
          canScan = true;
          lastVerified = TimeOfDay.now().format(context);
        });
      }
    });
  }

  void _changeDay(String direction) {
    setState(() {
      if (direction == 'next') {
        currentDayIndex = (currentDayIndex + 1) % daysOfWeek.length;
      } else {
        currentDayIndex =
            (currentDayIndex - 1 + daysOfWeek.length) % daysOfWeek.length;
      }
    });
  }

  String _getDateString(int index) {
    // Mock date logic
    final todayIndex = 2; // Wed
    final diff = index - todayIndex;
    final date = DateTime.now().add(Duration(days: diff));
    // Simple formatting
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return "${months[date.month - 1]} ${date.day}";
  }

  @override
  Widget build(BuildContext context) {
    final currentDayName = daysOfWeek[currentDayIndex];
    final todaysClasses = mockSchedule[currentDayName] ?? [];
    final hours = List.generate(10, (i) => i + 9); // 9 to 18

    return Column(
      children: [
        const CustomSearchBar(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            children: [
              // Actions
              _buildScanButton(),
              const SizedBox(height: 12),
              _buildVerifyButton(),
              if (locationStatus == 'success')
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "Last verified: $lastVerified • Valid for 1h",
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.gray400),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 32),

              // Classes Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Classes",
                          style: AppTextStyles.h3
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                          "$currentDayName, ${_getDateString(currentDayIndex)}",
                          style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.gray500,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Row(
                    children: [
                      _buildIconButton(LucideIcons.calendar, () {
                        setState(() => currentDayIndex = 2);
                      }, active: true),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.gray100),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            _buildIconButton(LucideIcons.chevronLeft,
                                () => _changeDay('prev'),
                                size: 20, padding: 6),
                            Container(
                                width: 1,
                                height: 16,
                                color: AppColors.gray100,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4)),
                            _buildIconButton(LucideIcons.chevronRight,
                                () => _changeDay('next'),
                                size: 20, padding: 6),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildIconButton(LucideIcons.maximize2, _showTimetable),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Timeline
              Stack(
                children: [
                  Positioned(
                    left: 29,
                    top: 8,
                    bottom: 0,
                    child: Container(width: 2, color: AppColors.gray100),
                  ),
                  Column(
                    children: hours.map((hour) {
                      final classItem = todaysClasses.firstWhere(
                        (c) => c.start == hour,
                        orElse: () => ScheduleItem(
                            id: -1,
                            start: -1,
                            end: -1,
                            subject: "",
                            faculty: "",
                            credits: 0,
                            attendance: 0,
                            status: ""),
                      );

                      final timeStr = "$hour:00";
                      final endTimeStr = "${hour + 1}:00";

                      if (classItem.id != -1) {
                        return ClassItemCard(
                          startTime: timeStr,
                          endTime: endTimeStr,
                          subject: classItem.subject,
                          status: classItem.status,
                          instructor: classItem.faculty,
                          credits: classItem.credits,
                          attendance: classItem.attendance,
                        );
                      } else {
                        return IdleItemCard(time: timeStr);
                      }
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScanButton() {
    return GestureDetector(
      onTap: canScan ? _showScanner : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: canScan ? AppColors.blue600 : AppColors.gray100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: canScan
              ? [
                  BoxShadow(
                    color: AppColors.blue600.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: canScan
                        ? AppColors.white.withOpacity(0.2)
                        : AppColors.gray200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(LucideIcons.qrCode,
                      color: canScan ? AppColors.white : AppColors.gray400,
                      size: 24),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Scan QR Code",
                        style: AppTextStyles.h3.copyWith(
                            color:
                                canScan ? AppColors.white : AppColors.gray400,
                            fontWeight: FontWeight.bold)),
                    Text(canScan ? "Ready to scan" : "Verify location first",
                        style: AppTextStyles.bodySmall.copyWith(
                            color: canScan
                                ? AppColors.blue100
                                : AppColors.gray400)),
                  ],
                ),
              ],
            ),
            if (canScan)
              const Icon(LucideIcons.chevronRight, color: AppColors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    Color bgColor = AppColors.white;
    Color textColor = AppColors.blue600;
    IconData icon = LucideIcons.mapPin;
    String text = "Verify Location";

    if (locationStatus == 'verifying') {
      bgColor = AppColors.gray50;
      textColor = AppColors.gray500;
      icon = LucideIcons.loader2;
      text = "Checking...";
    } else if (locationStatus == 'success') {
      bgColor = AppColors.green50;
      textColor = AppColors.green700;
      icon = LucideIcons.checkCircle2;
      text = "Location Verified";
    }

    return GestureDetector(
      onTap: (locationStatus == 'success' || locationStatus == 'verifying')
          ? null
          : _handleVerifyLocation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: 8),
            Text(text,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: textColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap,
      {bool active = false, double size = 16, double padding = 8}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: active ? AppColors.blue50 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            size: size, color: active ? AppColors.blue600 : AppColors.gray600),
      ),
    );
  }
}
