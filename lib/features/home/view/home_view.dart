import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/features/home/view/widgets/dashboard_charts.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
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
          Gap(20),
          DashboardStatsGrid(),
          Gap(30),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.bar_chart, color: AppColors.accentBlue, size: 28.sp),
              Gap(10),
              Text(
                'Student GPA Distribution',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Gap(10),
          DashboardCharts(),
        ],
      ),
    );
  }
}

class DashboardStatsGrid extends StatelessWidget {
  const DashboardStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 20.w,
      mainAxisSpacing: 20.h,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _StatCard(
          title: 'Total Students',
          value: '120',
          color: AppColors.accentBlue,
        ),
        _StatCard(
          title: 'Departments',
          value: '5',
          color: AppColors.accentGreen,
        ),
        _StatCard(title: 'Courses', value: '60', color: AppColors.accentCyan),
        _StatCard(
          title: 'Average GPA',
          value: '2.5',
          color: AppColors.accentOrange,
        ),
      ],
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
