import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_info_system/core/constant/app_colors.dart';

class CustomSearchButton extends StatelessWidget {
  const CustomSearchButton({
    super.key,
    required this.text,
    this.isSelected = false,
  });
  final String text;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: AppColors.accentBlue,
      child: Container(
        margin: EdgeInsets.only(top: 10.h, right: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentBlue
              : AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(20.0.r),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 20.sp),
        ),
      ),
    );
  }
}
