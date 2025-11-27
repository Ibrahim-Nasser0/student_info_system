import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/core/shared/custom_botton.dart';
import 'package:student_info_system/data/repository/course_repository.dart';
import 'package:student_info_system/data/repository/student_repository.dart';
import 'package:student_info_system/features/courses/viewModel/cubit/courses_cubit.dart';
import 'package:student_info_system/features/students/viewModel/cubit/student_cubit.dart';

class ImportData extends StatelessWidget {
  const ImportData({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<StudentCubit>(
            create: (context) => StudentCubit(StudentRepository()),
          ),
          BlocProvider<CourseCubit>(
            create: (context) => CourseCubit(CourseRepository()),
          ),
        ],
        child: Builder(
          builder: (contextInsideProvider) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Import Data from CSV',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Gap(20),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        tittle: 'Import Students',
                        onPressed: () =>
                            _pickAndImportStudents(contextInsideProvider),
                      ),
                    ),
                    const Gap(10),

                    Expanded(
                      child: CustomButton(
                        tittle: 'Import Courses',
                        onPressed: () =>
                            _pickAndImportCourses(contextInsideProvider),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Future<void> _pickAndImportStudents(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
  );

  if (result != null && result.files.single.path != null) {
    final filePath = result.files.single.path!;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting Student CSV import...'),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      await context.read<StudentCubit>().importStudents(filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Students imported successfully and list refreshed!'),
          backgroundColor: AppColors.accentBlue,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Student Import Failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

Future<void> _pickAndImportCourses(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
  );

  if (result != null && result.files.single.path != null) {
    final filePath = result.files.single.path!;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting Course CSV import...'),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      await context.read<CourseCubit>().importCourses(filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Courses imported successfully and list refreshed!'),
          backgroundColor: Colors.blueGrey,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Course Import Failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
