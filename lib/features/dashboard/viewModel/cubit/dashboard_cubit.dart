import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_info_system/data/repository/student_repository.dart';
import 'package:student_info_system/data/repository/course_repository.dart';
import 'package:student_info_system/data/repository/department_repository.dart';
import 'package:student_info_system/features/dashboard/viewModel/cubit/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final StudentRepository studentRepo;
  final CourseRepository courseRepo;
  final DepartmentRepository departmentRepo;

  DashboardCubit({
    required this.studentRepo,
    required this.courseRepo,
    required this.departmentRepo,
  }) : super(DashboardInitial());

  Future<Map<String, dynamic>> getGPADistribution() async {
    final students = await studentRepo.getAll();

    double above35 = 0;
    double above30 = 0;
    double above25 = 0;
    double below25 = 0;

    for (var s in students) {
      if (s.gpa >= 3.5) {
        above35++;
      } else if (s.gpa >= 3.0)
        above30++;
      else if (s.gpa >= 2.5)
        above25++;
      else
        below25++;
    }

    return {
      'above35': above35,
      'above30': above30,
      'above25': above25,
      'below25': below25,
      'total': students.length,
    };
  }

  Future<void> loadDashboardData() async {
    emit(DashboardLoading());
    try {
      final students = await studentRepo.getAll();
      final courses = await courseRepo.getAll();
      final departments = await departmentRepo.getAllDepartmentNames();
      final averageGPA = await studentRepo.getAverageGPA();
      final topStudents = await studentRepo.getTopStudents(5);
      final topDepartments = await departmentRepo.getTopDepartments(10);
      final gpaDistribution = await getGPADistribution();

      emit(
        DashboardLoaded(
          totalStudents: students.length,
          totalCourses: courses.length,
          totalDepartments: departments.length,
          gpaDistribution: gpaDistribution,
          averageGPA: averageGPA,
          topStudents: topStudents,
          topDepartments: topDepartments,
        ),
      );
    } catch (e) {
      emit(DashboardError("Failed to load dashboard: $e"));
    }
  }
}
