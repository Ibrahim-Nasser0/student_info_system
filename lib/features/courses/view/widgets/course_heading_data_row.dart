import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_info_system/core/constant/app_colors.dart';

class CourseHeadingDataRow extends StatelessWidget {
  const CourseHeadingDataRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80.h,
      decoration: BoxDecoration(
        color: AppColors.accentBlue,
        borderRadius: BorderRadius.circular(10.r),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Name',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Text(
                'Code',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Text(
                'Department',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'Credit Hours',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'Instructor',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Actions',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
