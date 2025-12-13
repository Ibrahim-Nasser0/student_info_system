import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_info_system/data/models/department_model.dart';
import 'package:student_info_system/data/repository/department_repository.dart';
import 'department_state.dart';

class DepartmentCubit extends Cubit<DepartmentState> {
  final DepartmentRepository _repository;

  DepartmentCubit(this._repository) : super(DepartmentInitial());

  Future<void> loadAllDepartmentNames() async {
    emit(DepartmentLoading());
    try {
      final names = await _repository.getAllDepartmentNames();
      emit(DepartmentNamesLoaded(names));
    } catch (e) {
      emit(DepartmentError("Failed to load the list of Department: $e"));
    }
  }

  Future<void> loadAllDepartmentDetails() async {
    emit(DepartmentLoading());
    try {
      final names = await _repository.getAllDepartmentNames();

      final departments = <DepartmentModel>[];
      for (var name in names) {
        final students = await _repository.getStudentsByDepartment(name);
        final courses = await _repository.getCoursesByDepartment(name);

        departments.add(
          DepartmentModel(
            name: name,
            code: name.substring(0, 2).toUpperCase(),
            enrolledStudents: students.length,
            totalCourses: courses.length,
            students: students,
            courses: courses,
          ),
        );
      }

      emit(DepartmentDetailsSummaryLoaded(departments));
    } catch (e) {
      emit(DepartmentError("Failed to load the Department:$e"));
    }
  }

  Future<void> loadDepartmentDetails(String departmentName) async {
    emit(DepartmentLoading());
    try {
      final students = await _repository.getStudentsByDepartment(
        departmentName,
      );
      final courses = await _repository.getCoursesByDepartment(departmentName);

      emit(
        DepartmentDetailsLoaded(
          departmentName: departmentName,
          students: students,
          courses: courses,
        ),
      );
    } catch (e) {
      emit(DepartmentError("Failed to load the detils of Department:$e"));
    }
  }

  Future<void> createReportFile(String departmentName) async {
    emit(DepartmentLoading());
    try {
      await _repository.createDepartmentFile(departmentName);
    } catch (e) {
      emit(DepartmentError("Failed $e"));
    }
  }
}
