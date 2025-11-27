import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/features/dashboard/models/progress_model.dart';
import 'package:student_info_system/features/dashboard/view/widgets/progress_bar.dart';
import 'package:student_info_system/features/dashboard/viewModel/cubit/dashboard_cubit.dart';
import 'package:student_info_system/features/dashboard/viewModel/cubit/dashboard_state.dart';

class DashboardCharts extends StatelessWidget {
  const DashboardCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is DashboardLoaded) {
          final total = state.gpaDistribution['total']!.toDouble();

          final progressModels = [
            ProgressModel(
              'GPA > 3.5',
              progress: state.gpaDistribution['above35']!,
              maxProgress: total,
            ),
            ProgressModel(
              'GPA > 3.0',
              progress: state.gpaDistribution['above30']!,
              maxProgress: total,
            ),
            ProgressModel(
              'GPA > 2.5',
              progress: state.gpaDistribution['above25']!,
              maxProgress: total,
            ),
            ProgressModel(
              'GPA < 2.5',
              progress: state.gpaDistribution['below25']!,
              maxProgress: total,
            ),
          ];

          return Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bar_chart,
                    color: AppColors.accentBlue,
                    size: 28.sp,
                  ),
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
              Container(
                height: 300.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(color: AppColors.shadow, blurRadius: 20),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
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
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
