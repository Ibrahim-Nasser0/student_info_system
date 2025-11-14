import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/core/shared/custom_botton.dart';
import 'package:student_info_system/features/departments/view/widgets/department_card.dart';

class DepartmentView extends StatelessWidget {
  const DepartmentView({super.key});
  final List<Map<String, dynamic>> departmentsData = const [
    {'name': 'Computer Science', 'code': 'CS', 'students': 120, 'courses': 15},
    {
      'name': 'Electrical Engineering',
      'code': 'EE',
      'students': 85,
      'courses': 12,
    },
    {
      'name': 'Business Administration',
      'code': 'BA',
      'students': 150,
      'courses': 20,
    },
    {'name': 'Arts & Humanities', 'code': 'AH', 'students': 95, 'courses': 18},
    {'name': 'Mathmtics', 'code': 'MT', 'students': 150, 'courses': 60},
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(45),
          Text(
            'Department View',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 38.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          Gap(20),
          CustomButton(tittle: 'Add Department'),
          Gap(20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عمودين في كل صف
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 2.6, // لضبط ارتفاع البطاقة
              ),
              itemCount: departmentsData.length,
              itemBuilder: (context, index) {
                final dept = departmentsData[index];
                return DepartmentCard(
                  departmentName: dept['name'],
                  departmentCode: dept['code'],
                  totalStudents: dept['students'],
                  totalCourses: dept['courses'],
                  onViewDetails: () {},
                  onEdit: () {},
                  onDelete: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
