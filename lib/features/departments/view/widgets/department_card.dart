import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';

// تعريف الألوان الأساسية المستخدمة في الثيم الداكن

class DepartmentCard extends StatelessWidget {
  final String departmentName;
  final String departmentCode;
  final int totalStudents;
  final int totalCourses;
  final VoidCallback onViewDetails;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DepartmentCard({
    super.key,
    required this.departmentName,
    required this.departmentCode,
    required this.totalStudents,
    required this.totalCourses,
    required this.onViewDetails,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.secondaryBackground, // لون خلفية البطاقة الداكن
      elevation: 4, // ظل خفيف لإبراز البطاقة
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: onViewDetails, // البطاقة بأكملها قابلة للنقر لعرض التفاصيل
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    departmentName,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    departmentCode,
                    style: TextStyle(
                      color: AppColors.accentBlue,
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Divider(color: AppColors.divider, height: 16),

             
              InfoRow(
                icon: Icons.people,
                label: 'Total Students:',
                value: '$totalStudents',
              ),
              Gap(8),
              InfoRow(
                icon: Icons.menu_book,
                label: 'Total Courses:',
                value: '$totalCourses',
              ),

              const Spacer(),

              // === 3. أزرار الإجراءات ===
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    tooltip: 'Delete Department',
                    onPressed: onDelete,
                  ),

                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.accentBlue),
                    tooltip: 'Edit Department',
                    onPressed: onEdit,
                  ),

                  TextButton.icon(
                    onPressed: onViewDetails,
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: AppColors.accentBlue,
                    ),
                    label: const Text(
                      'View Details',
                      style: TextStyle(color: AppColors.accentBlue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 18),
        const Gap(8),
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 30.sp),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 30.sp,
          ),
        ),
      ],
    );
  }
}
