import 'package:student_info_system/data/models/search_student_model.dart';

import '../file_manager.dart';
import '../../features/students/models/student_model.dart';
import '../storage/formats/record_format.dart';

class StudentRepository {
  final FileManager fileManager;
  final RecordFormat recordFormat;
  final String fileName;

  StudentRepository({
    required this.fileManager,
    required this.recordFormat,
    this.fileName = 'students.txt',
  });
  //  Get All Students  //
  Future<List<StudentModel>> getAll() async {
    if (!fileManager.exists(fileName)) return [];

    final raw = await fileManager.read(fileName);
    final records = recordFormat.decode(raw);

    return records.map((r) {
      return StudentModel(
        id: int.parse(r.fields[0]),
        name: r.fields[1],
        gpa: int.parse(r.fields[2]),
        department: r.fields[3],
        email: r.fields[4],
        phoneNumber: r.fields[5],
        level: r.fields[6],
      );
    }).toList();
  }

  // Add Student  //
  Future<void> add(StudentModel student) async {
    final existing = await getAll();
    existing.add(student);

    final data = recordFormat.encode(
      existing.map((s) {
        return Record([
          s.id.toString(),
          s.name,
          s.gpa.toString(),
          s.department,
          s.email,
          s.phoneNumber,
          s.level,
        ]);
      }).toList(),
    );

    await fileManager.write(fileName, data);
  }

  //  Delete Methods  //
  Future<bool> delete(int id) async {
    final existing = await getAll();
    final before = existing.length;

    existing.removeWhere((s) => s.id == id);

    if (existing.length == before) return false;

    final data = recordFormat.encode(
      existing.map((s) {
        return Record([
          s.id.toString(),
          s.name,
          s.gpa.toString(),
          s.department,
          s.email,
          s.phoneNumber,
          s.level,
        ]);
      }).toList(),
    );

    await fileManager.write(fileName, data);
    return true;
  }

  Future<void> deleteAll() async {
    if (fileManager.exists(fileName)) {
      await fileManager.write(fileName, "");
    }
  }

  //  Update Student  //
  Future<bool> update(StudentModel updated) async {
    final existing = await getAll();
    bool found = false;

    for (int i = 0; i < existing.length; i++) {
      if (existing[i].id == updated.id) {
        existing[i] = updated;
        found = true;
        break;
      }
    }

    if (!found) return false;

    final data = recordFormat.encode(
      existing.map((s) {
        return Record([
          s.id.toString(),
          s.name,
          s.gpa.toString(),
          s.department,
          s.email,
          s.phoneNumber,
          s.level,
        ]);
      }).toList(),
    );

    await fileManager.write(fileName, data);
    return true;
  }

  //  Searching Methods + Time Measure  //
  Future<SearchStudentModel> searchingWithID(int id) async {//TODO handle null
    final sw = Stopwatch()..start();

    final existing = await getAll();

    StudentModel? result;
    for (var s in existing) {
      if (s.id == id) {
        result = s;

        break;
      }
    }

    sw.stop();
    print("Search for '$id' took: ${sw.elapsedMicroseconds} μs");

    return SearchStudentModel(
      student: result!,
      timeInMicroseconds: sw.elapsedMicroseconds,
    );
  }

  Future<SearchStudentModel> searchingWithName(String name) async {
    final sw = Stopwatch()..start();

    final existing = await getAll();

    StudentModel? result;
    for (var s in existing) {
      if (s.name.toLowerCase() == name.toLowerCase()) {
        result = s;
        break;
      }
    }

    sw.stop();
    print("Search for '$name' took: ${sw.elapsedMicroseconds} μs");

    return SearchStudentModel(
      student: result!,
      timeInMicroseconds: sw.elapsedMicroseconds,
    );
  }

  Future<List<StudentModel>> searchingWithDepartment(String department) async {
    List<StudentModel> results = [];

    final existing = await getAll();

    for (var s in existing) {
      if (s.department.toLowerCase() == department.toLowerCase()) {
        results.add(s);
      }
    }

    print("Search for '$department' ");

    return results;
  }
}
