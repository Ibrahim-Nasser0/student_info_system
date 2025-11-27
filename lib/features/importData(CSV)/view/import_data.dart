import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/shared/custom_botton.dart';
import 'package:student_info_system/data/repository/course_repository.dart';
import 'package:student_info_system/data/repository/student_repository.dart';
import 'package:student_info_system/features/courses/viewModel/cubit/courses_cubit.dart';
import 'package:student_info_system/features/importData(CSV)/view/widgets/import_courses.dart';
import 'package:student_info_system/features/importData(CSV)/view/widgets/import_students.dart';
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
                            pickAndImportStudents(contextInsideProvider),
                      ),
                    ),
                    const Gap(10),

                    Expanded(
                      child: CustomButton(
                        tittle: 'Import Courses',
                        onPressed: () =>
                            pickAndImportCourses(contextInsideProvider),
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
