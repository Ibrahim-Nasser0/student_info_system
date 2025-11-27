import 'package:student_info_system/data/models/course_model.dart';
import 'package:student_info_system/data/models/search_course_model.dart';

abstract class CourseState {}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

// حالة عرض القائمة الكاملة
class CourseLoaded extends CourseState {
  final List<CourseModel> courses;
  CourseLoaded(this.courses);
}

// حالة عرض نتائج البحث (تحتوي على وقت البحث)
class CourseSearchLoaded extends CourseState {
  final List<SearchCourseModel> results;
  CourseSearchLoaded(this.results);
}

class CourseError extends CourseState {
  final String message;
  CourseError(this.message);
}
