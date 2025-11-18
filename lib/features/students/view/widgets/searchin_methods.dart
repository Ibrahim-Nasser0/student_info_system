import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/core/shared/custom_botton.dart';
import 'package:student_info_system/core/shared/custom_text_field.dart';
import 'package:student_info_system/features/students/models/searching_methods_model.dart';
import 'package:student_info_system/features/students/view/widgets/custom_search_botton.dart';

class SearchingStudentMethods extends StatelessWidget {
  SearchingStudentMethods({super.key});

  final List<SearchingMethodsModel> searchingMethods = [
    SearchingMethodsModel(text: 'Name', index: 0),
    SearchingMethodsModel(text: 'ID', index: 1),
    SearchingMethodsModel(text: 'Department', index: 2),
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
            CustomButton(
              tittle: 'Add Student',
              onPressed: () => showAddStudentPopup(context),
            ),
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
          ],
        ),
      ],
    );
  }
}

void showAddStudentPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      // Controllers عشان نحتفظ بالبيانات المدخلة
      final nameController = TextEditingController();
      final idController = TextEditingController();
      final deptController = TextEditingController();
      final gpaController = TextEditingController();

      return AlertDialog(
        backgroundColor: AppColors.secondaryBackground,
        title: const Text(
          'Add New Student',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(hintText: 'Name', controller: nameController),
              Gap(10),
              CustomTextField(hintText: 'ID', controller: idController),
              Gap(10),
              CustomTextField(
                hintText: 'Department',
                controller: deptController,
              ),
              Gap(10),
              CustomTextField(hintText: 'GPA', controller: gpaController),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // لإغلاق البوب أب
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
          CustomButton(
            tittle: 'Add',
            onPressed: () {
              String name = nameController.text;
              String id = idController.text;
              String dept = deptController.text;
              String gpa = gpaController.text;

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
