import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/features/dashboard/models/progress_model.dart';
import 'package:student_info_system/features/dashboard/view/widgets/progress_bar.dart';

class DashboardCharts extends StatelessWidget {
  const DashboardCharts({super.key});
  static final List<ProgressModel> progressModels = [
    ProgressModel('GPA > 3.5', progress: 5, maxProgress: 120),
    ProgressModel('GPA > 3.0', progress: 30, maxProgress: 120),
    ProgressModel('GPA > 2.5', progress: 40, maxProgress: 120),
    ProgressModel('GPA < 2.5', progress: 45, maxProgress: 120),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 20)],
      ),
      padding: EdgeInsets.symmetric(horizontal: 80.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProgressBar(
            progressModel: progressModels[0],
            color: AppColors.accentBlue,
          ),

          ProgressBar(
            progressModel: progressModels[1],
            color: AppColors.accentGreen,
          ),

          ProgressBar(
            progressModel: progressModels[2],
            color: AppColors.accentOrange,
          ),

          ProgressBar(
            progressModel: progressModels[3],
            color: AppColors.accentRed,
          ),
        ],
      ),
    );
  }
}
