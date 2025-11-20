import '../file_manager.dart';
import '../storage/formats/record_format.dart';
import '../../features/courses/models/course_model.dart';

class CourseRepository {//TODO not Tested
  final FileManager fileManager;
  final RecordFormat recordFormat;
  final String fileName;

  CourseRepository({
    required this.fileManager,
    required this.recordFormat,
    this.fileName = 'courses.txt',
  });

  // -------------------------------------------------------------------------
  // Get All Courses
  // -------------------------------------------------------------------------
  Future<List<CourseModel>> getAll() async {
    if (!fileManager.exists(fileName)) return [];

    final raw = await fileManager.read(fileName);
    final records = recordFormat.decode(raw);

    return records.map((r) {
      return CourseModel(
        name: r.fields[0],
        code: r.fields[1],
        creditHours: int.parse(r.fields[2]),
        enrolledStudents: int.parse(r.fields[3]),
        instructor: r.fields[4],
        department: r.fields[5],
      );
    }).toList();
  }

  // -------------------------------------------------------------------------
  // Add Course
  // -------------------------------------------------------------------------
  Future<void> add(CourseModel course) async {
    final existing = await getAll();
    existing.add(course);

    final data = recordFormat.encode(
      existing.map((c) {
        return Record([
          c.name,
          c.code,
          c.creditHours.toString(),
          c.enrolledStudents.toString(),
          c.instructor,
          c.department,
        ]);
      }).toList(),
    );

    await fileManager.write(fileName, data);
  }

  // -------------------------------------------------------------------------
  // Delete Course
  // -------------------------------------------------------------------------
  Future<bool> delete(String courseCode) async {
    final existing = await getAll();
    final before = existing.length;

    existing.removeWhere((c) => c.code == courseCode);

    if (existing.length == before) return false;

    final data = recordFormat.encode(
      existing.map((c) {
        return Record([
          c.name,
          c.code,
          c.creditHours.toString(),
          c.enrolledStudents.toString(),
          c.instructor,
          c.department,
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

  // -------------------------------------------------------------------------
  // Update Course
  // -------------------------------------------------------------------------
  Future<bool> update(CourseModel updated) async {
    final existing = await getAll();
    bool found = false;

    for (int i = 0; i < existing.length; i++) {
      if (existing[i].code == updated.code) {
        existing[i] = updated;
        found = true;
        break;
      }
    }

    if (!found) return false;

    final data = recordFormat.encode(
      existing.map((c) {
        return Record([
          c.name,
          c.code,
          c.creditHours.toString(),
          c.enrolledStudents.toString(),
          c.instructor,
          c.department,
        ]);
      }).toList(),
    );

    await fileManager.write(fileName, data);
    return true;
  }

  // -------------------------------------------------------------------------
  // Searching
  // -------------------------------------------------------------------------

  /// search by Course Code (unique)
  Future<CourseModel?> searchByCode(String code) async {
    final sw = Stopwatch()..start();
    final existing = await getAll();

    final result = existing.firstWhere(
      (c) => c.code.toLowerCase() == code.toLowerCase(),
      //orElse: () => null,
    );

    sw.stop();
    print("Search for code '$code' took: ${sw.elapsedMicroseconds} μs");

    return result;
  }

  /// search by Name
  Future<CourseModel?> searchByName(String name) async {
    final existing = await getAll();

    return existing.firstWhere(
      (c) => c.name.toLowerCase() == name.toLowerCase(),
     // orElse: () => null,
    );
  }

  /// search by department (may return multiple courses)
  Future<List<CourseModel>> searchByDepartment(String department) async {
    final existing = await getAll();
    final q = department.toLowerCase().trim();

    return existing
        .where((c) => c.department.toLowerCase().trim() == q)
        .toList();
  }
}
