import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/core/shared/custom_botton.dart';
import 'package:student_info_system/core/shared/custom_text_field.dart';
import 'package:student_info_system/features/departments/models/department_model.dart';
import 'package:student_info_system/features/departments/view/widgets/department_card.dart';

class DepartmentView extends StatefulWidget {
  const DepartmentView({super.key});

  @override
  State<DepartmentView> createState() => _DepartmentViewState();
}

class _DepartmentViewState extends State<DepartmentView> {
  List<DepartmentModel> departments = [
    DepartmentModel(
      name: 'Computer Science',
      code: 'CS',
      totalCourses: 120,
      enrolledStudents: 150,
    ),
    DepartmentModel(
      name: 'Electrical Engineering',
      code: 'EE',
      totalCourses: 100,
      enrolledStudents: 85,
    ),
    DepartmentModel(
      name: 'Business Administration',
      code: 'BA',
      totalCourses: 130,
      enrolledStudents: 150,
    ),
    DepartmentModel(
      name: 'Arts & Humanities',
      code: 'AH',
      totalCourses: 110,
      enrolledStudents: 95,
    ),
    DepartmentModel(
      name: 'Mathmtics',
      code: 'MT',
      totalCourses: 200,
      enrolledStudents: 150,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(45),
          Text(
            'Department View',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 38.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
          const Gap(20),
          CustomButton(
            tittle: 'Add Department',
            onPressed: () async {
              await showAddDepartmentPopup(context, departments);
              setState(() {});
            },
          ),
          const Gap(20),
          DepartmentGrid(departments: departments),
        ],
      ),
    );
  }
}

class DepartmentGrid extends StatefulWidget {
  const DepartmentGrid({super.key, required this.departments});

  final List<DepartmentModel> departments;

  @override
  State<DepartmentGrid> createState() => _DepartmentGridState();
}

class _DepartmentGridState extends State<DepartmentGrid> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimationLimiter(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 2.3,
          ),
          itemCount: widget.departments.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: Duration(milliseconds: 500 + index * 200),
              columnCount: 2,
              child: ScaleAnimation(
                duration: Duration(milliseconds: 1600),
                curve: Curves.fastLinearToSlowEaseIn,
                child: DepartmentCard(
                  departmentName: widget.departments[index].name,
                  departmentCode: widget.departments[index].code,
                  totalStudents: widget.departments[index].enrolledStudents,
                  totalCourses: widget.departments[index].totalCourses,
                  onViewDetails: () {},
                  onEdit: () async {
                    await EdaitDepartmentPopup(
                      context,
                      widget.departments[index],
                    );
                    setState(() {});
                  },
                  onDelete: () {
                    setState(() {
                      widget.departments.removeAt(index);
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future showAddDepartmentPopup(BuildContext context, departments) {
  return showDialog(
    context: context,
    builder: (context) {
      // Controllers عشان نحتفظ بالبيانات المدخلة
      final nameController = TextEditingController();
      final codeController = TextEditingController();

      return AlertDialog(
        backgroundColor: AppColors.secondaryBackground,
        title: const Text(
          'Add New Department',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(hintText: 'Name', controller: nameController),
              Gap(10),
              CustomTextField(hintText: 'Code', controller: codeController),
              Gap(10),
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
              DepartmentModel newDepartment = DepartmentModel(
                name: nameController.text,
                code: codeController.text,
              );
              departments.add(newDepartment);

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future EdaitDepartmentPopup(BuildContext context, DepartmentModel department) {
  return showDialog(
    context: context,
    builder: (context) {
      // Controllers عشان نحتفظ بالبيانات المدخلة
      final nameController = TextEditingController(text: department.name);
      final codeController = TextEditingController(text: department.code);

      return AlertDialog(
        backgroundColor: AppColors.secondaryBackground,
        title: const Text(
          'Add New Department',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(hintText: 'Name', controller: nameController),
              Gap(10),
              CustomTextField(hintText: 'Code', controller: codeController),
              Gap(10),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
          CustomButton(
            tittle: 'Save',
            onPressed: () {
              department.name = nameController.text;
              department.code = codeController.text;
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
