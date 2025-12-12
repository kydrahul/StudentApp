import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/data_models.dart';
import '../../services/api_service.dart';
import '../../widgets/common/search_bar.dart';
import '../../widgets/cards/class_item_card.dart';
import '../../widgets/cards/idle_item_card.dart';

import '../weekly_timetable_screen.dart';
import '../course_detail_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final ApiService _apiService = ApiService();
  Map<String, List<ScheduleItem>> _schedule = {};
  List<Course> _allCourses = [];
  List<Course> _filteredCourses = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    // Set current day index based on actual day
    final now = DateTime.now();
    if (now.weekday >= 1 && now.weekday <= 5) {
      currentDayIndex = now.weekday - 1;
    }
  }

  Future<void> _fetchData() async {
    try {
      // Fetch Timetable
      final timetableData = await _apiService.getTimetable();
      final Map<String, List<ScheduleItem>> parsedSchedule = {};

      timetableData.forEach((day, classes) {
        parsedSchedule[day] = (classes as List).map((json) {
          return ScheduleItem.fromJson({
            ...json,
            'status': 'Upcoming',
          });
        }).toList();
      });

      // Fetch Courses (for Search & Details)
      final rawCourses = await _apiService.getCourses();
      final courses = rawCourses.map((json) => Course.fromJson(json)).toList();

      if (mounted) {
        setState(() {
          _schedule = parsedSchedule;
          _allCourses = courses;
          _filteredCourses = courses; // Init filtered list
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredCourses = _allCourses;
      } else {
        _filteredCourses = _allCourses.where((course) {
          final q = query.toLowerCase();
          return course.name.toLowerCase().contains(q) ||
              course.id.toLowerCase().contains(q) ||
              course.faculty.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _filteredCourses = _allCourses;
      FocusScope.of(context).unfocus();
    });
  }

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

  void _handleVerifyLocation() async {
    // ... existing verify logic ...
    setState(() {
      locationStatus = 'verifying';
    });

    try {
      final permission = await Permission.location.request();
      if (!permission.isGranted) {
        setState(() => locationStatus = 'neutral');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Location permission is required'),
                backgroundColor: Colors.red),
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 10));

      final result = await _apiService.verifyLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      );

      if (mounted) {
        setState(() {
          locationStatus = 'success';
          canScan = true;
          lastVerified = TimeOfDay.now().format(context);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(result['message'] ?? 'Location verified!'),
              backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          locationStatus = 'error';
          canScan = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: Colors.red),
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) setState(() => locationStatus = 'neutral');
        });
      }
    }
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
    final now = DateTime.now();
    final currentWeekday = now.weekday; // 1 = Mon
    final targetWeekday = index + 1;
    final diff = targetWeekday - currentWeekday;
    final date = now.add(Duration(days: diff));

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          CustomSearchBar(
            readOnly: false,
            controller: _searchController,
            onChanged: _onSearchChanged,
            onClear: _searchQuery.isNotEmpty
                ? () {
                    _searchController.clear();
                    _onSearchChanged('');
                  }
                : null,
          ),
          Expanded(
            child: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: _clearSearch,
                    behavior: HitTestBehavior.opaque,
                    child: _buildSearchResults(),
                  )
                : _buildDashboardContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_filteredCourses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.searchX, size: 48, color: AppColors.gray400),
            const SizedBox(height: 16),
            Text(
              "No results for '$_searchQuery'",
              style:
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.gray500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredCourses.length,
      itemBuilder: (context, index) {
        final course = _filteredCourses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          color: AppColors.white,
          child: InkWell(
            onTap: () => _openCourseDetail(course),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.blue50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(LucideIcons.bookOpen,
                        color: AppColors.blue600, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.name,
                          style: AppTextStyles.h4
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(LucideIcons.user,
                                size: 14, color: AppColors.gray500),
                            const SizedBox(width: 4),
                            Text(
                              course.faculty,
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: AppColors.gray600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(LucideIcons.chevronRight,
                      size: 20, color: AppColors.gray400),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleClassTap(String courseId) {
    if (courseId.isEmpty) return;

    try {
      final course = _allCourses.firstWhere((c) => c.id == courseId);
      _openCourseDetail(course);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Course details not found for ID: $courseId"),
            backgroundColor: AppColors.red600,
          ),
        );
      }
    }
  }

  void _openCourseDetail(Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailScreen(course: course),
      ),
    );
  }

  Widget _buildDashboardContent() {
    final currentDayName = daysOfWeek[currentDayIndex];
    final todaysClasses = _schedule[currentDayName] ?? [];
    final hours = List.generate(10, (i) => i + 9); // 9 to 18

    return RefreshIndicator(
      onRefresh: _fetchData,
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
                style:
                    AppTextStyles.bodySmall.copyWith(color: AppColors.gray400),
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
                  Text("$currentDayName, ${_getDateString(currentDayIndex)}",
                      style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray500,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              Row(
                children: [
                  _buildIconButton(LucideIcons.calendar, () {
                    final now = DateTime.now();
                    if (now.weekday >= 1 && now.weekday <= 5) {
                      setState(() => currentDayIndex = now.weekday - 1);
                    }
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
                        _buildIconButton(
                            LucideIcons.chevronLeft, () => _changeDay('prev'),
                            size: 20, padding: 6),
                        Container(
                            width: 1,
                            height: 16,
                            color: AppColors.gray100,
                            margin: const EdgeInsets.symmetric(horizontal: 4)),
                        _buildIconButton(
                            LucideIcons.chevronRight, () => _changeDay('next'),
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
          _isLoading
              ? const Center(
                  child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ))
              : Stack(
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
                              courseId: "",
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
                          // Try to find better faculty name from _allCourses
                          String facultyName = classItem.faculty;
                          if (facultyName == 'Unknown' || facultyName.isEmpty) {
                            try {
                              final course = _allCourses.firstWhere(
                                (c) => c.id == classItem.courseId,
                              );
                              if (course.faculty.isNotEmpty) {
                                facultyName = course.faculty;
                              }
                            } catch (_) {}
                          }

                          return ClassItemCard(
                            startTime: timeStr,
                            endTime: endTimeStr,
                            subject: classItem.subject,
                            status: classItem.status,
                            instructor: facultyName,
                            credits: classItem.credits,
                            attendance: classItem.attendance,
                            onTap: () => _handleClassTap(classItem.courseId),
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
