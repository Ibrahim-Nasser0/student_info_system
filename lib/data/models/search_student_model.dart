import 'package:student_info_system/features/students/models/student_model.dart';

class SearchStudentModel {
  final StudentModel student;
  final dynamic timeInMicroseconds;
  SearchStudentModel({required this.student, required this.timeInMicroseconds});
}
