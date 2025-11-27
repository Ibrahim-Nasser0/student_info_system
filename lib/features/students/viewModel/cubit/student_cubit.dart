import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_info_system/data/models/student_model.dart';
import 'package:student_info_system/data/repository/student_repository.dart';
import 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  final StudentRepository _repository;

  StudentCubit(this._repository) : super(StudentInitial());

  // ======================= LOAD DATA =======================

  Future<void> loadStudents() async {
    emit(StudentLoading());
    try {
      final students = await _repository.getAll();

      emit(StudentLoaded(students));
    } catch (e) {
      emit(StudentError("فشل تحميل البيانات: $e"));
    }
  }

  // ======================= CRUD OPERATIONS =======================

  Future<void> addStudent(StudentModel student) async {
    emit(StudentLoading());
    try {
      await _repository.add(student);
      // بعد الإضافة، نعيد تحميل القائمة لتحديث الواجهة
      await loadStudents();
    } catch (e) {
      emit(StudentError("فشل إضافة الطالب: $e"));
    }
  }

  Future<void> importStudents(String filePath) async {
    // 1. عرض حالة التحميل
    emit(StudentLoading());
    try {
      await _repository.importStudentsFromCsv(filePath: filePath);

      // 3. إعادة تحميل القائمة لتحديث الواجهة بالبيانات الجديدة
      await loadStudents();

      // ملاحظة: دالة loadStudents() ستغير الحالة إلى StudentLoaded عند النجاح.
    } catch (e) {
      // 4. عرض حالة الخطأ إذا فشل الاستيراد
      emit(StudentError("فشل استيراد بيانات الطلاب من CSV: $e"));
      // نعيد تحميل البيانات القديمة حتى لا تبقى الشاشة فارغة
      loadStudents();
    }
  }

  Future<void> updateStudent(StudentModel student) async {
    emit(StudentLoading());
    try {
      final success = await _repository.update(student);
      if (success) {
        await loadStudents(); // تحديث القائمة
      } else {
        emit(StudentError("الطالب غير موجود لتعديله"));
        // نعيد تحميل البيانات القديمة حتى لا تبقى الشاشة في حالة خطأ
        loadStudents();
      }
    } catch (e) {
      emit(StudentError("فشل تعديل البيانات: $e"));
    }
  }

  Future<void> deleteStudent(int id) async {
    emit(StudentLoading());
    try {
      final success = await _repository.delete(id);
      if (success) {
        await loadStudents();
      } else {
        emit(StudentError("لم يتم العثور على الطالب لحذفه"));
        loadStudents();
      }
    } catch (e) {
      emit(StudentError("فشل حذف الطالب: $e"));
    }
  }

  // ======================= SEARCH OPERATIONS =======================

  Future<void> searchByID(int id) async {
    emit(StudentLoading());
    try {
      final result = await _repository.searchByID(id);
      if (result != null) {
        // نضع النتيجة في قائمة لأن الـ State يتوقع قائمة
        emit(StudentSearchLoaded([result]));
      } else {
        emit(StudentError("This student does not exist"));
      }
    } catch (e) {
      emit(StudentError("Search Error$e"));
    }
  }

  Future<void> searchByName(String name) async {
    emit(StudentLoading());
    try {
      final result = await _repository.searchByName(name);
      if (result != null) {
        emit(StudentSearchLoaded([result]));
      } else {
        emit(StudentError("This student does not exist"));
      }
    } catch (e) {
      emit(StudentError("Search Error$e"));
    }
  }

  Future<void> searchByDepartment(String department) async {
    emit(StudentLoading());
    try {
      final results = await _repository.searchByDepartment(department);
      if (results.isNotEmpty) {
        emit(StudentSearchLoaded(results));
      } else {
        emit(StudentError("This student does not exist"));
      }
    } catch (e) {
      emit(StudentError("Search Error$e"));
    }
  }

  Future<void> searchByGPARange(double min, double max) async {
    emit(StudentLoading());
    try {
      final results = await _repository.searchByGPARange(min, max);
      if (results.isNotEmpty) {
        emit(StudentSearchLoaded(results));
      } else {
        emit(StudentError("There are no student at this GPA"));
      }
    } catch (e) {
      emit(StudentError("Search Error$e"));
    }
  }

  void clearSearch() {
    loadStudents();
  }
}
