import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/data/repository/course_repository.dart';
import 'package:student_info_system/features/courses/view/widgets/searchin_methods.dart';
import 'package:student_info_system/features/courses/view/widgets/courses_table.dart';
import 'package:student_info_system/features/courses/viewModel/cubit/courses_cubit.dart';


class CoursesView extends StatelessWidget {
  const CoursesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocProvider(
        create: (context) => CourseCubit(CourseRepository())..loadCourses(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(45),
            Text(
              'Courses List',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 38.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            Gap(20),
            SearchingCoursesMethods(),
            Gap(20),
            CoursesTable(),
          ],
        ),
      ),
    );
  }
}

