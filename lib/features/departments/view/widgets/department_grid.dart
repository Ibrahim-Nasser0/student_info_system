import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:student_info_system/data/models/department_model.dart';
import 'package:student_info_system/features/departments/view/widgets/department_card.dart';
import 'package:student_info_system/features/departments/view/widgets/show_department_details.dart';

class DepartmentGrid extends StatelessWidget {
  const DepartmentGrid({super.key, required this.departments});

  final List<DepartmentModel> departments;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 2.5,
        ),
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final department = departments[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: Duration(milliseconds: 500 + index * 200),
            columnCount: 2,
            child: ScaleAnimation(
              duration: const Duration(milliseconds: 1200),
              curve: Curves.fastLinearToSlowEaseIn,
              child: DepartmentCard(
                context: context,
                departmentName: department.name,
                departmentCode: department.code,
                totalStudents: department.enrolledStudents,
                totalCourses: department.totalCourses,
                onViewDetails: () {
                  showDepartmentDetailsPopup(
                    context,
                    department.name,
                    department.students,
                    department.courses,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
