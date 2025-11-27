import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/data/repository/student_repository.dart';
import 'package:student_info_system/features/students/view/widgets/searchin_methods.dart';
import 'package:student_info_system/features/students/view/widgets/students_table.dart';
import 'package:student_info_system/features/students/viewModel/cubit/student_cubit.dart';

class StudentView extends StatelessWidget {
  const StudentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocProvider(
        create: (context) => StudentCubit(StudentRepository())..loadStudents(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(45),
            Text(
              'Student List',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 38.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const Gap(20),
            const SearchingStudentMethods(),
            const Gap(20),
            const StudentTable(),
          ],
        ),
      ),
    );
  }
}
