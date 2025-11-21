class Student {
  final String userId;
  final String email;
  final String name;
  final String rollNo;
  final String? department;
  final String? year;
  final String? batch;
  final String? semester;

  Student({
    required this.userId,
    required this.email,
    required this.name,
    required this.rollNo,
    this.department,
    this.year,
    this.batch,
    this.semester,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      rollNo: json['rollNo'] ?? '',
      department: json['department'],
      year: json['year'],
      batch: json['batch'],
      semester: json['semester'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'rollNo': rollNo,
      'department': department,
      'year': year,
      'batch': batch,
      'semester': semester,
    };
  }
}
