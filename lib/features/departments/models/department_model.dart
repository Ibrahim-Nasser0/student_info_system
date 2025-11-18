class DepartmentModel {
  String name;
  String code;
  int totalCourses;
  int enrolledStudents;

  DepartmentModel({
    required this.name,
    required this.code,
    this.totalCourses = 0,
    this.enrolledStudents = 0,
  });
}
