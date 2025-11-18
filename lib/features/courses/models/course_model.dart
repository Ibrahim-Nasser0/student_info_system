class CourseModel {
  final String name;
  final String code;
  final int creditHours;
  final int enrolledStudents;
  final String instructor;
  final String department;

  CourseModel({
    required this.name,
    required this.code,
    required this.creditHours,
    required this.enrolledStudents,
    this.instructor = '',
    this.department = '',
  });
}
