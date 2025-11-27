import 'package:student_info_system/data/models/student_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int totalStudents;
  final int totalCourses;
  final int totalDepartments;
  final double averageGPA;
  final List<StudentModel> topStudents;
  final List<MapEntry<String, double>> topDepartments;
  Map<String, dynamic> gpaDistribution;

  DashboardLoaded({
    required this.gpaDistribution,
    required this.totalStudents,
    required this.totalCourses,
    required this.totalDepartments,
    required this.averageGPA,
    required this.topStudents,
    required this.topDepartments,
  });
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
