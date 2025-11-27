import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/data/models/student_model.dart';
import 'package:student_info_system/data/repository/student_repository.dart';
import 'package:student_info_system/features/students/view/widgets/searchin_methods.dart';
import 'package:student_info_system/features/students/view/widgets/students_table.dart';
import 'package:student_info_system/features/students/viewModel/cubit/student_cubit.dart';
import 'package:student_info_system/features/students/viewModel/cubit/student_state.dart';

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
            Gap(45),
            Text(
              'Student List',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 38.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            Gap(20),
            SearchingStudentMethods(),
            Gap(20),
            StudentTable(),
          ],
        ),
      ),
    );
  }
}

class StudentHeadingDataRow extends StatelessWidget {
  const StudentHeadingDataRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80.h,
      decoration: BoxDecoration(
        color: AppColors.accentBlue,
        borderRadius: BorderRadius.circular(10.r),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Name',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Text(
                'ID',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Text(
                'Department',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'Level',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'GPA',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Actions',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentDataRow extends StatelessWidget {
  const StudentDataRow({super.key, required this.student});
  final StudentModel student;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.h,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(10.r),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                student.name,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Text(
                student.id.toString(),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Text(
                student.department,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                student.level,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                student.gpa.toString(),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BlocConsumer<StudentCubit, StudentState>(
              listener: (context, state) {
                if (state is StudentError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },

              builder: (context, state) {
                return Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showAddOrEditStudentPopup(context, student: student);

                          context.read<StudentCubit>().updateStudent(student);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: AppColors.textPrimary,
                          size: 30.sp,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          context.read<StudentCubit>().deleteStudent(
                            student.id,
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          color: AppColors.accentRed,
                          size: 30.sp,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
