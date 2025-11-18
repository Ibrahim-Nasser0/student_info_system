class StudentModel {
  final int id;
  final String name;
  final int gpa;
  final String department;
  final String email;
  final String phoneNumber;
  final String level;

  StudentModel({
    required this.id,
    required this.name,
    required this.gpa,
    this.department = '',
    this.email = '',
    this.phoneNumber = '',
    this.level = 'one',
  });
}
