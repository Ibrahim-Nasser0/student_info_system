import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:student_info_system/core/constant/app_colors.dart';

class DashboardStatsGrid extends StatelessWidget {
  const DashboardStatsGrid({super.key});

  final List<_StatCard> statCards = const [
    _StatCard(
      title: 'Total Students',
      value: '120',
      color: AppColors.accentBlue,
    ),
    _StatCard(title: 'Departments', value: '5', color: AppColors.accentGreen),
    _StatCard(title: 'Courses', value: '60', color: AppColors.accentCyan),
    _StatCard(
      title: 'Average GPA',
      value: '2.5',
      color: AppColors.accentOrange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int columnCount = (screenWidth ~/ 200).clamp(1, 4);

    return AnimationLimiter(
      child: GridView.builder(
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
