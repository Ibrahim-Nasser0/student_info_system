import 'package:student_info_system/data/models/department_model.dart';
import 'package:student_info_system/data/models/student_model.dart';
import 'package:student_info_system/data/models/course_model.dart';

abstract class DepartmentState {}

class DepartmentInitial extends DepartmentState {}

class DepartmentLoading extends DepartmentState {}

// حالة عرض قائمة بأسماء الأقسام الفريدة المتاحة
class DepartmentNamesLoaded extends DepartmentState {
  final Set<String> departmentNames;
  DepartmentNamesLoaded(this.departmentNames);
}

// حالة عرض تفاصيل قسم معين
class DepartmentDetailsLoaded extends DepartmentState {
  final String departmentName;
  final List<StudentModel> students;
  final List<CourseModel> courses;

  DepartmentDetailsLoaded({
    required this.departmentName,
    required this.students,
    required this.courses,
  });
}

class DepartmentError extends DepartmentState {
  final String message;
  DepartmentError(this.message);
}

class DepartmentDetailsSummaryLoaded extends DepartmentState {
  final List<DepartmentModel> departments;
  DepartmentDetailsSummaryLoaded(this.departments);
}
