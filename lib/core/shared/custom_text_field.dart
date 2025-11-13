import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_info_system/core/constant/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Icon? prefixIcon;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700.w,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.textPrimary.withOpacity(0.5)),

          prefixIcon: prefixIcon,
          prefixIconColor: AppColors.textPrimary.withOpacity(0.7),

       
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none, 
          ),

          fillColor: AppColors.secondaryBackground,
          filled: true,

       
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
        
            borderSide: const BorderSide(
              color: AppColors.accentBlue,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
