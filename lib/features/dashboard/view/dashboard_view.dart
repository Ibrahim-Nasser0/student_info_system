import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/data/repository/course_repository.dart';
import 'package:student_info_system/data/repository/department_repository.dart';
import 'package:student_info_system/data/repository/student_repository.dart';
import 'package:student_info_system/features/dashboard/view/widgets/dashboard_charts.dart';
import 'package:student_info_system/features/dashboard/view/widgets/dashboard_stats_grid.dart';
import 'package:student_info_system/features/dashboard/view/widgets/top_departments_list.dart';
import 'package:student_info_system/features/dashboard/view/widgets/top_students_list.dart';
import 'package:student_info_system/features/dashboard/viewModel/cubit/dashboard_cubit.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: BlocProvider(
        create: (context) => DashboardCubit(
          studentRepo: StudentRepository(),
          courseRepo: CourseRepository(),
          departmentRepo: DepartmentRepository(),
        )..loadDashboardData(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 38.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(20),
            const DashboardStatsGrid(),
            const Gap(30),

            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: TopStudentsList()),
                Gap(10),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [TopDepartments(), Gap(10), DashboardCharts()],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
