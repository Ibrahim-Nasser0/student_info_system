import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_info_system/data/models/course_model.dart';
import 'package:student_info_system/data/repository/course_repository.dart';
import 'package:student_info_system/features/courses/viewModel/cubit/courses_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseRepository _repository;

  CourseCubit(this._repository) : super(CourseInitial());

  // ======================= LOAD DATA =======================

  Future<void> loadCourses() async {
    emit(CourseLoading());
    try {
      final courses = await _repository.getAll();
      emit(CourseLoaded(courses));
    } catch (e) {
      emit(CourseError("Course loading failed:$e"));
    }
  }

  // ======================= CRUD OPERATIONS =======================

  Future<void> addCourse(CourseModel course) async {
    emit(CourseLoading());
    try {
      await _repository.add(course);
      await loadCourses();
    } catch (e) {
   
      emit(CourseError(e.toString().replaceAll("Exception:", "")));
     
      loadCourses();
    }
  }

  Future<void> importCourses(String filePath) async {
   
    emit(CourseLoading());
    try {
  
      await _repository.importCoursesFromCsv(filePath: filePath);


      await loadCourses();

   
    } catch (e) {
   
      emit(CourseError("Failed to import course data from CSV:$e"));
     
      loadCourses();
    }
  }

  Future<void> updateCourse(CourseModel course) async {
    emit(CourseLoading());
    try {
      final success = await _repository.update(course);
      if (success) {
        await loadCourses();
      } else {
        emit(CourseError("The course could not be found to update."));
        loadCourses();
      }
    } catch (e) {
      emit(CourseError("Course update failed:$e"));
      loadCourses();
    }
  }

  Future<void> deleteCourse(String code) async {
    emit(CourseLoading());
    try {
      final success = await _repository.delete(code);
      if (success) {
        await loadCourses();
      } else {
        emit(CourseError("The course could not be found to delete."));
        loadCourses();
      }
    } catch (e) {
      emit(CourseError("Course deletion failed:$e"));
      loadCourses();
    }
  }

  Future<void> deleteAllCourses() async {
    emit(CourseLoading());

    await _repository.deleteAll();
  }

  // ======================= SEARCH OPERATIONS =======================

  Future<void> searchByCode(String code) async {
    emit(CourseLoading());
    try {
      final result = await _repository.searchByCode(code);
      if (result != null) {
     
        emit(CourseSearchLoaded([result]));
      } else {
        emit(CourseError("No course was found with this code."));
       
         loadCourses();
      }
    } catch (e) {
      emit(CourseError("An error occurred during the search: $e"));
    }
  }


  void clearSearch() {
    loadCourses();
  }
}
