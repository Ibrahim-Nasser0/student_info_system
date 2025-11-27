
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/features/auth/view/widgets/footer.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/navSidebar/view/side_bar.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(children: [Spacer(), LoginCard(), Spacer(), const Footer()]),
    );
  }
}

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 700.w,
        height: 500.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider, width: 3.w),
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.secondaryBackground,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              offset: Offset(0, 5),
              blurRadius: 10,
            ),
          ],
        ),

        child: Column(
          children: [
            Gap(40),
            Text(
              'Login',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 40.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: Column(
                children: [
                  CustomTextField(labelText: 'Username'),
                  Gap(20),
                  CustomTextField(labelText: 'Password', obscureText: true),
                ],
              ),
            ),

            Gap(40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SideBar()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                padding: EdgeInsets.symmetric(
                  horizontal: 100.w,
                  vertical: 15.h,
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22.sp,
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

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
  });
  final String labelText;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      style: TextStyle(color: AppColors.textPrimary, fontSize: 20.sp),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: AppColors.textSecondary, fontSize: 18.sp),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.divider, width: 2.w),
          borderRadius: BorderRadius.circular(20.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.accentBlue, width: 2.w),
        ),
      ),
    );
  }
}
