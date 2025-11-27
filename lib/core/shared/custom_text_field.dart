import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_info_system/core/constant/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Icon? prefixIcon;

  // ✅ الخصائص الجديدة
  final void Function(String)? onChanged; // للبحث الفوري
  final bool readOnly; // لقفل الحقل (مثل الـ ID عند التعديل)
  final TextInputType? keyboardType; // لتحديد نوع الكيبورد (أرقام/نص)
  final double? width; // للتحكم بالعرض يدويًا إذا احتجنا

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.prefixIcon,
    this.onChanged,
    this.readOnly = false, // القيمة الافتراضية false (مسموح الكتابة)
    this.keyboardType,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ نستخدم العرض الممرر، وإذا لم يمرر نستخدم 700 كقيمة افتراضية
      // لكن داخل الـ Dialog يفضل أن يأخذ العرض المتاح، لذا قد تحتاج تمرير width: double.infinity
      width: width ?? 700.w,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged, // ✅ ربط دالة التغيير
        readOnly: readOnly, // ✅ تفعيل خاصية القراءة فقط
        keyboardType: keyboardType, // ✅ نوع لوحة المفاتيح

        style: TextStyle(
          color: readOnly
              ? AppColors.textPrimary.withOpacity(0.5)
              : AppColors.textPrimary,
        ),

        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.textPrimary.withOpacity(0.5)),

          prefixIcon: prefixIcon,
          prefixIconColor: AppColors.textPrimary.withOpacity(0.7),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),

          // تغيير لون الخلفية قليلاً إذا كان الحقل للقراءة فقط لتمييزه
          fillColor: readOnly
              ? AppColors.secondaryBackground.withOpacity(0.5)
              : AppColors.secondaryBackground,
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
