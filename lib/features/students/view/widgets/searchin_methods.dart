import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/core/shared/custom_botton.dart';
import 'package:student_info_system/core/shared/custom_text_field.dart';
import 'package:student_info_system/features/students/view/widgets/custom_search_botton.dart';

class SearchingStudentMethods extends StatelessWidget {
  const SearchingStudentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomTextField(
              hintText: 'Search',
              controller: TextEditingController(),
              prefixIcon: const Icon(Icons.search),
            ),
            Gap(20),
            CustomButton(tittle: 'Add Student'),
          ],
        ),
        Text(
          'Searching With: ',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 25.sp),
        ),
        Row(
          children: [
            CustomSearchButton(text: 'Name', isSelected: true),
            Gap(10),
            CustomSearchButton(text: 'ID'),
            Gap(10),
            CustomSearchButton(text: 'Department'),
          ],
        ),
      ],
    );
  }
}
