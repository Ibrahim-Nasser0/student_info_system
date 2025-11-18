import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/core/shared/custom_botton.dart';
import 'package:student_info_system/core/shared/custom_text_field.dart';
import 'package:student_info_system/features/students/models/searching_methods_model.dart';
import 'package:student_info_system/core/shared/custom_search_botton.dart';

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
        SearchRow(searchingMethods: searchingMethods),
      ],
    );
  }
}

class SearchRow extends StatefulWidget {
  const SearchRow({super.key, required this.searchingMethods});

  final List<SearchingMethodsModel> searchingMethods;

  @override
  State<SearchRow> createState() => _SearchRowState();
}

class _SearchRowState extends State<SearchRow> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        widget.searchingMethods.length,
        (index) => Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CustomSearchButton(
            searchingMethods: widget.searchingMethods[index],
            onTap: () {
              setState(() {
                selectedIndex = index; // حدّد الزر المختار
              });
            },
            isSelected: selectedIndex == index, // اللون يعتمد على selectedIndex
          ),
        ),
      ),
    );
  }
}
