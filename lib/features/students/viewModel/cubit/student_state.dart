import 'package:student_info_system/data/models/search_student_model.dart';
import 'package:student_info_system/data/models/student_model.dart';

abstract class StudentState {}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<StudentModel> students;
  StudentLoaded(this.students);
}

class StudentSearchLoaded extends StudentState {
  final List<SearchStudentModel> results;
  StudentSearchLoaded(this.results);
}

class StudentActionSuccess extends StudentState {
  final String message;
  StudentActionSuccess(this.message);
}

class StudentError extends StudentState {
  final String message;
  StudentError(this.message);
}
