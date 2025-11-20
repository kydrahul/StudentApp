class ScheduleItem {
  final int id;
  final int start;
  final int end;
  final String subject;
  final String faculty;
  final int credits;
  final int attendance;
  final String status; // "Present", "Absent", "Upcoming"

  ScheduleItem({
    required this.id,
    required this.start,
    required this.end,
    required this.subject,
    required this.faculty,
    required this.credits,
    required this.attendance,
    required this.status,
  });
}

class Course {
  final int id;
  final String name;
  final String faculty;
  final int credits;
  final int attendance;
  final int totalClasses;
  final int attended;
  final int missed;
  final ContactInfo contact;
  final List<ClassSchedule> schedule;

  Course({
    required this.id,
    required this.name,
    required this.faculty,
    required this.credits,
    required this.attendance,
    required this.totalClasses,
    required this.attended,
    required this.missed,
    required this.contact,
    required this.schedule,
  });
}

class ContactInfo {
  final String phone;
  final String email;

  ContactInfo({required this.phone, required this.email});
}

class ClassSchedule {
  final String day;
  final String time;
  final String room;

  ClassSchedule({required this.day, required this.time, required this.room});
}

class AttendanceRecord {
  final int id;
  final String date;
  final String time;
  final String status; // "Present", "Absent"

  AttendanceRecord({
    required this.id,
    required this.date,
    required this.time,
    required this.status,
  });
}
