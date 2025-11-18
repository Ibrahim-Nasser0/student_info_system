import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/core/shared/custom_botton.dart';
import 'package:student_info_system/core/shared/custom_text_field.dart';
import 'package:student_info_system/features/students/models/searching_methods_model.dart';
import 'package:student_info_system/features/students/view/widgets/custom_search_botton.dart';

class SearchingCoursesMethods extends StatelessWidget {
  SearchingCoursesMethods({super.key});

  final List<SearchingMethodsModel> searchingMethods = [
    SearchingMethodsModel(text: 'Code', index: 0),
    SearchingMethodsModel(text: 'Name', index: 1),
    SearchingMethodsModel(text: 'Creadit Hours', index: 2),
    SearchingMethodsModel(text: 'Enrolled Students', index: 3),
    SearchingMethodsModel(text: 'Department', index: 4),
  ];
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
            CustomButton(tittle: 'Add Course'),
          ],
        ),
        Text(
          'Searching With: ',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 25.sp),
        ),
        Row(
          children: [
            CustomSearchButton(searchingMethods: searchingMethods[0]),
            Gap(10),
            CustomSearchButton(searchingMethods: searchingMethods[1]),
            Gap(10),
            CustomSearchButton(searchingMethods: searchingMethods[2]),
            Gap(10),
            CustomSearchButton(searchingMethods: searchingMethods[3]),
            Gap(10),
            CustomSearchButton(searchingMethods: searchingMethods[4]),
          ],
        ),
      ],
    );
  }
}
