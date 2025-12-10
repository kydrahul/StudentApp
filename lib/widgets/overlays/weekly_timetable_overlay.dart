import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../constants/colors.dart';

enum CellType { header, time, classCell, idle, breakCell }

class WeeklyTimetableOverlay extends StatelessWidget {
  final VoidCallback onClose;

  const WeeklyTimetableOverlay({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header - Ultra compressed
            Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  bottom: BorderSide(color: AppColors.gray300),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Week Schedule",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Spring",
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gray50,
                          border: Border.all(color: AppColors.gray200),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "3rd sem DSAI 2025",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onClose,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.gray100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.x,
                            size: 16,
                            color: AppColors.gray600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Timetable Grid - Ultra compressed
            Expanded(
              child: Container(
                color: AppColors.background,
                padding: const EdgeInsets.all(4),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _buildTimetableGrid(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimetableGrid() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gray300,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.gray300),
      ),
      child: Column(
        children: [
          // Header Row
          _buildHeaderRow(),

          // Time Rows
          _build9AMRow(),
          _build10AMRow(),
          _build11AMRow(),
          _build12PMRow(),
          _build1PMRow(), // Lunch
          _build2PMRow(),
          _build3PMRow(),
          _build4PMRow(),
          _build5PMRow(),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        _buildCell("Time", CellType.header, width: 30),
        _buildCell("Mon", CellType.header, width: 60),
        _buildCell("Tue", CellType.header, width: 60),
        _buildCell("Wed", CellType.header, width: 60),
        _buildCell("Thu", CellType.header, width: 60),
        _buildCell("Fri", CellType.header, width: 60),
      ],
    );
  }

  Widget _build9AMRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCell("9:00", CellType.time, width: 30, height: 48),
        _buildCell("idle", CellType.idle, width: 60, height: 48),
        _buildCell("Intro Robots", CellType.classCell,
            width: 60, height: 96), // Spans 2 rows
        _buildCell("Data Struct", CellType.classCell, width: 60, height: 48),
        _buildCell("Data Struct", CellType.classCell, width: 60, height: 48),
        _buildCell("Graph Theory", CellType.classCell,
            width: 60, height: 96), // Spans 2 rows
      ],
    );
  }

  Widget _build10AMRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCell("10:00", CellType.time, width: 30, height: 48),
        _buildCell("DBMS-1", CellType.classCell, width: 60, height: 48),
        const SizedBox(width: 60), // Occupied by Robotics
        _buildCell("DBMS-1", CellType.classCell, width: 60, height: 48),
        _buildCell("AI Found.", CellType.classCell, width: 60, height: 48),
        const SizedBox(width: 60), // Occupied by Graph Theory
      ],
    );
  }

  Widget _build11AMRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCell("11:00", CellType.time, width: 30, height: 48),
        _buildCell("Data Lab", CellType.classCell,
            width: 60, height: 96), // Spans 2 rows
        _buildCell("AI Found.", CellType.classCell,
            width: 60, height: 96), // Spans 2 rows
        _buildCell("AI Found.", CellType.classCell, width: 60, height: 48),
        _buildCell("Intro Robots", CellType.classCell, width: 60, height: 48),
        _buildCell("DBMS Lab", CellType.classCell,
            width: 60, height: 96), // Spans 2 rows
      ],
    );
  }

  Widget _build12PMRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCell("12:00", CellType.time, width: 30, height: 48),
        const SizedBox(width: 60), // Occupied
        const SizedBox(width: 60), // Occupied
        _buildCell("OOAD", CellType.classCell, width: 60, height: 48),
        _buildCell("Graph Theory", CellType.classCell, width: 60, height: 48),
        const SizedBox(width: 60), // Occupied
      ],
    );
  }

  Widget _build1PMRow() {
    return Row(
      children: [
        _buildCell("1:00", CellType.time, width: 30, height: 48),
        _buildCell("Lunch", CellType.breakCell,
            width: 250, height: 48), // Spans 5 columns
      ],
    );
  }

  Widget _build2PMRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCell("2:00", CellType.time, width: 30, height: 48),
        _buildCell("Graph Theory", CellType.classCell, width: 60, height: 48),
        _buildCell("idle", CellType.idle, width: 60, height: 48),
        _buildCell("Intro Robots", CellType.classCell,
            width: 60, height: 96), // Spans 2 rows
        _buildCell("DBMS-1", CellType.classCell, width: 60, height: 48),
        _buildCell("OOAD", CellType.classCell,
            width: 60, height: 96), // Spans 2 rows
      ],
    );
  }

  Widget _build3PMRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCell("3:00", CellType.time, width: 30, height: 48),
        _buildCell("Intro Robots", CellType.classCell, width: 60, height: 48),
        _buildCell("DBMS-1", CellType.classCell, width: 60, height: 48),
        const SizedBox(width: 60), // Occupied
        _buildCell("OOAD", CellType.classCell, width: 60, height: 48),
        const SizedBox(width: 60), // Occupied
      ],
    );
  }

  Widget _build4PMRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCell("4:00", CellType.time, width: 30, height: 48),
        _buildCell("OOAD", CellType.classCell,
            width: 60, height: 96), // Spans 2 rows
        _buildCell("Graph Theory", CellType.classCell,
            width: 60, height: 96), // Spans 2 rows
        _buildCell("idle", CellType.idle,
            width: 60, height: 96), // Spans 2 rows
        _buildCell("DBMS-1", CellType.classCell, width: 50, height: 48),
      ],
    );
  }

  Widget _build5PMRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCell("5:00", CellType.time, width: 25, height: 48),
        const SizedBox(width: 50), // Occupied
        const SizedBox(width: 50), // Occupied
        const SizedBox(width: 50), // Occupied
        const SizedBox(width: 50), // Occupied
        _buildCell("idle", CellType.idle, width: 50, height: 48),
      ],
    );
  }

  Widget _buildCell(
    String text,
    CellType type, {
    required double width,
    double height = 24,
  }) {
    Color bgColor;
    Color textColor;
    FontWeight fontWeight;
    double fontSize;
    TextStyle? textStyle;
    EdgeInsets padding;

    switch (type) {
      case CellType.header:
        bgColor = AppColors.gray100;
        textColor = AppColors.black;
        fontWeight = FontWeight.bold;
        fontSize = 7;
        padding = const EdgeInsets.symmetric(horizontal: 2, vertical: 8);
        textStyle = TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          letterSpacing: 0.5,
          color: textColor,
          height: 1.0,
        );
        break;
      case CellType.time:
        bgColor = AppColors.white;
        textColor = AppColors.gray500;
        fontWeight = FontWeight.normal;
        fontSize = 7;
        padding = const EdgeInsets.symmetric(horizontal: 2, vertical: 24);
        textStyle = TextStyle(
          fontFamily: 'monospace',
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
          height: 1.0,
        );
        break;
      case CellType.classCell:
        bgColor = AppColors.white;
        textColor = AppColors.black;
        fontWeight = FontWeight.normal;
        fontSize = 8;
        padding = const EdgeInsets.symmetric(horizontal: 2, vertical: 24);
        textStyle = TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
          height: 1.0,
        );
        break;
      case CellType.idle:
        bgColor = AppColors.gray50;
        textColor = AppColors.gray400;
        fontWeight = FontWeight.w300;
        fontSize = 8;
        padding = const EdgeInsets.symmetric(horizontal: 2, vertical: 24);
        textStyle = TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: FontStyle.italic,
          color: textColor,
          height: 1.0,
        );
        break;
      case CellType.breakCell:
        bgColor = AppColors.gray200;
        textColor = AppColors.black;
        fontWeight = FontWeight.bold;
        fontSize = 7;
        padding = const EdgeInsets.symmetric(horizontal: 2, vertical: 24);
        textStyle = TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: 1.5,
          color: textColor,
          height: 1.0,
        );
        break;
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: AppColors.gray300, width: 1),
      ),
      padding: padding,
      alignment: Alignment.center,
      child: Text(
        text.toUpperCase(),
        style: textStyle,
        textAlign: TextAlign.center,
        maxLines: 4,
        overflow: TextOverflow.visible,
      ),
    );
  }
}
