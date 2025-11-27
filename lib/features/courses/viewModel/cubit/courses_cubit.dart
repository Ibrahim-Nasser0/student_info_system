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
      emit(CourseError("فشل تحميل الكورسات: $e"));
    }
  }

  // ======================= CRUD OPERATIONS =======================

  Future<void> addCourse(CourseModel course) async {
    emit(CourseLoading());
    try {
      await _repository.add(course);
      await loadCourses(); // إعادة التحميل لتحديث القائمة
    } catch (e) {
      // هنا نمسك الـ Exception الخاص بتكرار الكود
      emit(CourseError(e.toString().replaceAll("Exception:", "")));
      // نعيد تحميل البيانات القديمة حتى لا تبقى الشاشة فارغة
      loadCourses();
    }
  }

  Future<void> importCourses(String filePath) async {
    // 1. عرض حالة التحميل
    emit(CourseLoading());
    try {
      // 2. استدعاء دالة الـ Repository (يجب أن تكون موجودة)
      await _repository.importCoursesFromCsv(filePath: filePath);

      // 3. إعادة تحميل القائمة لتحديث الواجهة بالبيانات الجديدة
      await loadCourses();

      // ملاحظة: دالة loadCourses() ستغير الحالة إلى CourseLoaded عند النجاح.
    } catch (e) {
      // 4. عرض حالة الخطأ إذا فشل الاستيراد
      emit(CourseError("فشل استيراد بيانات الكورسات من CSV: $e"));
      // نعيد تحميل البيانات القديمة حتى لا تبقى الشاشة فارغة
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
        emit(CourseError("الكورس غير موجود لتعديله"));
        loadCourses();
      }
    } catch (e) {
      emit(CourseError("فشل تعديل الكورس: $e"));
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
        emit(CourseError("لم يتم العثور على الكورس لحذفه"));
        loadCourses();
      }
    } catch (e) {
      emit(CourseError("فشل حذف الكورس: $e"));
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
        // نضع النتيجة في قائمة لتسهيل العرض في نفس الجدول
        emit(CourseSearchLoaded([result]));
      } else {
        emit(CourseError("لم يتم العثور على كورس بهذا الكود"));
        // اختياري: هل تريد العودة للقائمة الأصلية أم البقاء؟
        // loadCourses();
      }
    } catch (e) {
      emit(CourseError("حدث خطأ أثناء البحث: $e"));
    }
  }

  // دالة للعودة من وضع البحث إلى القائمة الكاملة
  void clearSearch() {
    loadCourses();
  }
}
