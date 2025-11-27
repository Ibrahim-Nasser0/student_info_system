import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/data/models/student_model.dart';
import 'package:student_info_system/features/dashboard/viewModel/cubit/dashboard_cubit.dart';
import 'package:student_info_system/features/dashboard/viewModel/cubit/dashboard_state.dart';

class TopStudentsList extends StatelessWidget {
  const TopStudentsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is DashboardLoaded) {
          final students = state.topStudents;

          if (students.isEmpty) {
            return Text(
              "No Students Available",
              style: TextStyle(color: AppColors.textSecondary),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardSectionTitle(
                icon: Icons.star,
                title: "Top 5 Students",
                iconColor: AppColors.accentOrange,
              ),
              Gap(10.h),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    return StudentItemCard(
                      index: index,
                      student: students[index],
                    );
                  },
                ),
              ),
            ],
          );
        }

        return SizedBox();
      },
    );
  }
}

class DashboardSectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;

  const DashboardSectionTitle({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 26),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class StudentItemCard extends StatelessWidget {
  final int index;
  final StudentModel student;

  const StudentItemCard({
    super.key,
    required this.index,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    double gpaPercent = (student.gpa / 4.0).clamp(0.0, 1.0);

    return Container(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark.withOpacity(0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.accentBlue,
            child: Text(
              "${index + 1}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 4),
                Text(
                  "GPA: ${student.gpa}",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),

                SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: gpaPercent,
                    minHeight: 6,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(AppColors.accentGreen),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 10),
          Icon(Icons.keyboard_arrow_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
