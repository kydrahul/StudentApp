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
  final String id; // Changed to String to match backend
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

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      faculty: json['faculty'] ?? '',
      credits: json['credits'] ?? 0,
      attendance: json['attendance'] ?? 0,
      totalClasses: json['totalClasses'] ?? 0,
      attended: json['attended'] ?? 0,
      missed: json['missed'] ?? 0,
      contact: ContactInfo.fromJson(json['contact'] ?? {}),
      schedule: (json['schedule'] as List<dynamic>?)
              ?.map((e) => ClassSchedule.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ContactInfo {
  final String phone;
  final String email;

  ContactInfo({required this.phone, required this.email});

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class ClassSchedule {
  final String day;
  final String time;
  final String room;

  ClassSchedule({required this.day, required this.time, required this.room});

  factory ClassSchedule.fromJson(Map<String, dynamic> json) {
    return ClassSchedule(
      day: json['day'] ?? '',
      time: json['time'] ?? '',
      room: json['room'] ?? '',
    );
  }
}

class AttendanceRecord {
  final String id; // Changed to String
  final String date;
  final String time;
  final String status; // "Present", "Absent"

  AttendanceRecord({
    required this.id,
    required this.date,
    required this.time,
    required this.status,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id']?.toString() ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? 'Absent',
    );
  }
}
