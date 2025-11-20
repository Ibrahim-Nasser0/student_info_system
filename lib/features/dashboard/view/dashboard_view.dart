import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/features/dashboard/view/widgets/dashboard_charts.dart';
import 'package:student_info_system/features/dashboard/view/widgets/dashboard_stats_grid.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
          Row(
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
          const Gap(10),
          const DashboardCharts(),
        ],
      ),
    );
  }
}

