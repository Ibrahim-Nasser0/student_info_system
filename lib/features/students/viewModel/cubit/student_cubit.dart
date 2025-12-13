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
      emit(StudentError("faild load students$e"));
    }
  }

  // ======================= CRUD OPERATIONS =======================

  Future<void> addStudent(StudentModel student) async {
    emit(StudentLoading());
    try {
      await _repository.add(student);

      await loadStudents();
    } catch (e) {
      emit(StudentError("faild to add the student$e"));
    }
  }

  Future<void> importStudents(String filePath) async {

    emit(StudentLoading());
    try {
      await _repository.importStudentsFromCsv(filePath: filePath);

      await loadStudents();
    } catch (e) {
      emit(StudentError("failed to import the students from the CSV file$e"));

      loadStudents();
    }
  }

  Future<void> updateStudent(StudentModel student) async {
    emit(StudentLoading());
    try {
      final success = await _repository.update(student);
      if (success) {
        await loadStudents();
      } else {
        emit(StudentError("Student does not exit to edit"));
       
        loadStudents();
      }
    } catch (e) {
      emit(StudentError("failed to edit: $e"));
    }
  }

  Future<void> deleteStudent(int id) async {
    emit(StudentLoading());
    try {
      final success = await _repository.delete(id);
      if (success) {
        await loadStudents();
      } else {
        emit(StudentError("can not find the student to delete"));
        loadStudents();
      }
    } catch (e) {
      emit(StudentError("failed to delete to the student: $e"));
    }
  }

  Future<void> deleteAllStudents() async {
    emit(StudentLoading());

    await _repository.deleteAll();
  }

  // ======================= SEARCH OPERATIONS =======================

  Future<void> searchByID(int id) async {
    emit(StudentLoading());
    try {
      final result = await _repository.searchByID(id);
      if (result != null) {
      
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
