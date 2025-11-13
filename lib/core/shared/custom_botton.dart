import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.tittle});
  final String tittle;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},

      child: Container(
        height: 60.h,
        width: 200.w,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 12.h),
        decoration: BoxDecoration(
          color: AppColors.accentBlue,
          borderRadius: BorderRadius.circular(15.0.r),
        ),
        child: Row(
          children: [
            Icon(Icons.add, color: Colors.white, size: 24.sp),
            Gap(10),
            Text(
              tittle,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
