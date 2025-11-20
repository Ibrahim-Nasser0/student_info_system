// import 'dart:io';

// import 'file_manager.dart';
// import 'helpers/time_measure.dart';
// import '../features/students/models/student_model.dart';
// import 'repository/student_repository.dart';
// import 'storage/formats/record/delimited_record.dart';
// import 'storage/formats/record/fixed_lenght_record.dart';
// import 'storage/migration/ile_migrator.dart';

// void main() async {
//   // تأكد إن فولدر الملفات موجود
//   final filesDir = Directory('files');
//   if (!filesDir.existsSync()) {
//     filesDir.createSync(recursive: true);
//   }

//   final fm = FileManager();
//   final fixedFormat = FixedLengthRecordFormat([5, 20, 5]);
//   final delimitedFormat = DelimitedRecordFormat('|');

//   final repo = StudentRepository(
//     fileManager: fm,
//     recordFormat: fixedFormat,
//     fileName: 'students.txt',
//   );

//   bool exit = false;

//   do {
//     print('''
// === Student Info System ===
// 1. Add Student
// 2. View All Students
// 3. Update Student
// 4. Delete Student
// 5. Search Student
// 6. Delete All Students
// 7. Migrate File (Fixed -> Delimited)
// 0. Exit
// Choose an option: ''');
//     String? choice = stdin.readLineSync();

//     switch (choice) {
//       case '1':
//         stdout.write('ID: ');
//         int id = int.parse(stdin.readLineSync()!);
//         stdout.write('Name: ');
//         String name = stdin.readLineSync()!;
//         stdout.write('GPA: ');
//         int gpa = int.parse(stdin.readLineSync()!);

//         await TimeMeasure.measureAsync('Add Student', () async {
//           await repo.add(StudentModel(id: id, name: name, gpa: gpa));
//         });

//         print('Student added.');
//         break;

//       case '2':
//         final students = await TimeMeasure.measureAsync(
//           'Read Students',
//           () async {
//             return await repo.getAll();
//           },
//         );

//         print('Students:');
//         for (var s in students) {
//           print('${s.id} | ${s.name} | ${s.gpa}');
//         }
//         break;

//       case '3':
//         stdout.write('ID to update: ');
//         int id = int.parse(stdin.readLineSync()!);
//         stdout.write('New Name: ');
//         String name = stdin.readLineSync()!;
//         stdout.write('New GPA: ');
//         int gpa = int.parse(stdin.readLineSync()!);

//         bool updated = await repo.update(
//           StudentModel(id: id, name: name, gpa: gpa),
//         );
//         print(updated ? 'Student updated.' : 'Student not found.');
//         break;

//       case '4':
//         stdout.write('ID to delete: ');
//         String id = stdin.readLineSync()!;
//         bool deleted = await repo.delete(id);
//         print(deleted ? 'Student deleted.' : 'Student not found.');
//         break;

//       case '5':
//         stdout.write('ID to search: ');
//         String id = stdin.readLineSync()!;
//         var result = await repo.searchingWithID(id);
//         if (result != null && result != null) {
//           var s = result.student as StudentModel;
//           print('Found: ${s.id} | ${s.name} | ${s.gpa}');
//           print('Search took: ${result['time']} μs');
//         } else {
//           print('Student not found.');
//         }
//         break;

//       case '6':
//         if (fm.exists('files/students.txt')) {
//           await fm.delete('files/students.txt');
//           print('All students deleted.');
//         } else {
//           print('No student file found.');
//         }
//         break;

//       case '7':
//         final migrator = FileMigrator(
//           sourceFormat: fixedFormat,
//           targetFormat: delimitedFormat,
//         );
//         await TimeMeasure.measureAsync('File Migration', () async {
//           await migrator.migrate(
//             'files/students.txt',
//             'files/students_delimited.txt',
//           );
//         });
//         print('Migration complete.');
//         break;

//       case '0':
//         exit = true;
//         break;

//       default:
//         print('Invalid option.');
//     }
//     print('\n');
//   } while (!exit);
// }
