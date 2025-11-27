import 'package:student_info_system/data/models/search_student_model.dart';
import 'package:student_info_system/data/models/student_model.dart';

abstract class StudentState {}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

// حالة عرض جميع الطلاب
class StudentLoaded extends StudentState {
  final List<StudentModel> students;
  StudentLoaded(this.students);
}

// حالة عرض نتائج البحث (لأنها تحتوي على وقت البحث)
class StudentSearchLoaded extends StudentState {
  final List<SearchStudentModel> results;
  StudentSearchLoaded(this.results);
}

// حالة عند حدوث عملية بنجاح (مثل الحذف أو التعديل) إذا أردت عرض رسالة
class StudentActionSuccess extends StudentState {
  final String message;
  StudentActionSuccess(this.message);
}

class StudentError extends StudentState {
  final String message;
  StudentError(this.message);
}
