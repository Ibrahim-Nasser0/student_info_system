import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/features/dashboard/viewModel/cubit/dashboard_cubit.dart';
import 'package:student_info_system/features/dashboard/viewModel/cubit/dashboard_state.dart';

class DashboardStatsGrid extends StatelessWidget {
  const DashboardStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int columnCount = (screenWidth ~/ 200).clamp(1, 4);

    return AnimationLimiter(
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is DashboardError) {
            return Center(
              child: Text(state.message, style: TextStyle(color: Colors.red)),
            );
          }

          if (state is DashboardLoaded) {
            final statCards = [
              _StatCard(
                title: 'Total Students',
                value: state.totalStudents.toString(),
                color: AppColors.accentBlue,
              ),
              _StatCard(
                title: 'Departments',
                value: state.totalDepartments.toString(),
                color: AppColors.accentGreen,
              ),
              _StatCard(
                title: 'Courses',
                value: state.totalCourses.toString(),
                color: AppColors.accentCyan,
              ),
              _StatCard(
                title: 'Average GPA',
                value: state.averageGPA.toStringAsFixed(2),
                color: AppColors.accentOrange,
              ),
            ];

            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnCount,
                crossAxisSpacing: 20.w,
                mainAxisSpacing: 20.h,
                childAspectRatio: 1.2,
              ),
              itemCount: statCards.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: Duration(milliseconds: 500 + index * 200),
                  columnCount: columnCount,
                  child: ScaleAnimation(
                    duration: Duration(milliseconds: 1600),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: FadeInAnimation(child: statCards[index]),
                  ),
                );
              },
            );
          }

          return SizedBox();
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          colors: [
            AppColors.secondaryBackground,
            AppColors.secondaryBackground.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 35.sp),
          ),
          Spacer(),
          Center(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 55.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
