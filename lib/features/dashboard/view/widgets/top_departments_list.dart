import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/features/dashboard/viewModel/cubit/dashboard_cubit.dart';
import 'package:student_info_system/features/dashboard/viewModel/cubit/dashboard_state.dart';

class TopDepartments extends StatelessWidget {
  const TopDepartments({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DashboardLoaded) {
          final departments = state.topDepartments;

          return Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                "Top Departments",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              const Gap(10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...departments.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _DepartmentItem(name: e.key, gpa: e.value),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return const Text("Error loading departments");
      },
    );
  }
}

class _DepartmentItem extends StatelessWidget {
  final String name;
  final double gpa;

  const _DepartmentItem({required this.name, required this.gpa});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 27.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          gpa.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 27.sp,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
