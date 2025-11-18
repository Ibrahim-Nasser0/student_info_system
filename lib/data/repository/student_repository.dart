import '../file_manager.dart';
import '../models/student_model.dart';
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

  Future<List<Student>> getAll() async {
    if (!fileManager.exists(fileName)) return [];
    final raw = await fileManager.read(fileName);
    final records = recordFormat.decode(raw);
    return records.map((r) {
      return Student(id: r.fields[0], name: r.fields[1], gpa: r.fields[2]);
    }).toList();
  }

  Future<void> add(Student student) async {
    final existing = await getAll();
    existing.add(student);

    final data = recordFormat.encode(
      existing.map((s) => Record([s.id, s.name, s.gpa])).toList(),
    );

    await fileManager.write(fileName, data);
  }

  // ============================
  // 🔥 DELETE
  // ============================
  Future<bool> delete(String id) async {
    final existing = await getAll();
    final before = existing.length;

    existing.removeWhere((s) => s.id == id);

    if (existing.length == before) return false; // مفيش حذف

    final data = recordFormat.encode(
      existing.map((s) => Record([s.id, s.name, s.gpa])).toList(),
    );

    await fileManager.write(fileName, data);
    return true;
  }

  Future<void> deleteAll() async {
    if (fileManager.exists(fileName)) {
      await fileManager.write(fileName, ""); // مسح المحتوى
    }
  }

  // ============================
  //  UPDATE
  // ============================
  Future<bool> update(Student updated) async {
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
      existing.map((s) => Record([s.id, s.name, s.gpa])).toList(),
    );

    await fileManager.write(fileName, data);
    return true;
  }

  // ============================
  // 🔥 SEARCH + TIME MEASURE
  // ============================
  Future<Map<String, dynamic>?> search(String id) async {
    final sw = Stopwatch()..start();

    final existing = await getAll();

    Student? result;
    for (var s in existing) {
      if (s.id == id) {
        result = s;
        break;
      }
    }

    sw.stop();
    print("Search for '$id' took: ${sw.elapsedMicroseconds} μs");

    Map<String, dynamic> results = {
      'student': result,
      'time': sw.elapsedMicroseconds,
    };
    return results;
  }
}
