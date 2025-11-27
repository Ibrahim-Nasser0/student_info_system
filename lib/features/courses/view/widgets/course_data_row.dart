import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/data/models/course_model.dart';
import 'package:student_info_system/features/courses/view/widgets/searchin_methods.dart';
import 'package:student_info_system/features/courses/viewModel/cubit/courses_cubit.dart';
import 'package:student_info_system/features/courses/viewModel/cubit/courses_state.dart';

class CourseDataRow extends StatelessWidget {
  const CourseDataRow({super.key, required this.course});
  final CourseModel course;
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
                course.name,
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
                course.code,
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
                course.department,
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
                course.creditHours.toString(),
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
                course.instructor,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BlocConsumer<CourseCubit, CourseState>(
              listener: (context, state) {
                if (state is CourseError) {
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
                          showAddOrEditCoursePopup(context, course: course);
                          context.read<CourseCubit>().updateCourse(course);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: AppColors.textPrimary,
                          size: 30.sp,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          context.read<CourseCubit>().deleteCourse(course.code);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: AppColors.accentRed,
                          size: 30.sp,
                        ),
                      ),
                      const Spacer(),
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
