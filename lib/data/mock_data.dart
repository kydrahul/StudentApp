import '../models/data_models.dart';

final Map<String, List<ScheduleItem>> mockSchedule = {
  'Wednesday': [
    ScheduleItem(
        id: 1,
        start: 9,
        end: 10,
        subject: "Data Structures",
        faculty: "Prof. Smith",
        credits: 4,
        attendance: 85,
        status: "Present"),
    ScheduleItem(
        id: 2,
        start: 11,
        end: 12,
        subject: "Web Development",
        faculty: "Prof. Doe",
        credits: 3,
        attendance: 92,
        status: "Present"),
    ScheduleItem(
        id: 3,
        start: 14,
        end: 15,
        subject: "Database Systems",
        faculty: "Prof. Brown",
        credits: 4,
        attendance: 78,
        status: "Upcoming"),
    ScheduleItem(
        id: 4,
        start: 16,
        end: 17,
        subject: "Soft Skills",
        faculty: "Prof. Wilson",
        credits: 2,
        attendance: 95,
        status: "Upcoming"),
  ],
  'Thursday': [
    ScheduleItem(
        id: 5,
        start: 10,
        end: 11,
        subject: "Operating Systems",
        faculty: "Prof. Johnson",
        credits: 4,
        attendance: 88,
        status: "Upcoming"),
    ScheduleItem(
        id: 6,
        start: 12,
        end: 13,
        subject: "Computer Networks",
        faculty: "Prof. Davis",
        credits: 3,
        attendance: 82,
        status: "Upcoming"),
  ],
};

final List<Course> mockEnrolledCourses = [
  Course(
    id: '1',
    name: "Data Structures",
    faculty: "Prof. Smith",
    credits: 4,
    attendance: 85,
    totalClasses: 20,
    attended: 17,
    missed: 3,
    contact: ContactInfo(phone: "+1 987-654-3210", email: "smith@college.edu"),
    schedule: [
      ClassSchedule(day: "Monday", time: "09:00 AM - 10:00 AM", room: "LH-101"),
      ClassSchedule(
          day: "Wednesday", time: "09:00 AM - 10:00 AM", room: "LH-101"),
      ClassSchedule(day: "Friday", time: "11:00 AM - 12:00 PM", room: "Lab-2"),
    ],
  ),
  Course(
    id: '2',
    name: "Web Development",
    faculty: "Prof. Doe",
    credits: 3,
    attendance: 92,
    totalClasses: 12,
    attended: 11,
    missed: 1,
    contact: ContactInfo(phone: "+1 555-012-3456", email: "doe@college.edu"),
    schedule: [
      ClassSchedule(day: "Tuesday", time: "02:00 PM - 04:00 PM", room: "Lab-4"),
      ClassSchedule(
          day: "Thursday", time: "10:00 AM - 11:00 AM", room: "LH-203"),
    ],
  ),
  Course(
    id: '3',
    name: "Database Systems",
    faculty: "Prof. Brown",
    credits: 4,
    attendance: 78,
    totalClasses: 18,
    attended: 14,
    missed: 4,
    contact: ContactInfo(phone: "+1 555-098-7654", email: "brown@college.edu"),
    schedule: [
      ClassSchedule(day: "Monday", time: "11:00 AM - 12:00 PM", room: "LH-102"),
      ClassSchedule(
          day: "Wednesday", time: "02:00 PM - 03:00 PM", room: "LH-102"),
      ClassSchedule(
          day: "Thursday", time: "09:00 AM - 10:00 AM", room: "Lab-1"),
    ],
  ),
];

final List<AttendanceRecord> mockAttendanceHistory = [
  AttendanceRecord(
      id: '101', date: "2023-11-20", time: "09:00 AM", status: "Present"),
  AttendanceRecord(
      id: '102', date: "2023-11-18", time: "09:00 AM", status: "Present"),
  AttendanceRecord(
      id: '103', date: "2023-11-16", time: "09:00 AM", status: "Absent"),
  AttendanceRecord(
      id: '104', date: "2023-11-14", time: "09:00 AM", status: "Present"),
  AttendanceRecord(
      id: '105', date: "2023-11-12", time: "09:00 AM", status: "Present"),
  AttendanceRecord(
      id: '106', date: "2023-11-10", time: "09:00 AM", status: "Absent"),
  AttendanceRecord(
      id: '107', date: "2023-11-08", time: "09:00 AM", status: "Present"),
];
