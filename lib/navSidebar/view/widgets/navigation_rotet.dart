import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/features/auth/view/login_view.dart';
import 'package:student_info_system/features/courses/view/courses_view.dart';
import 'package:student_info_system/features/dashboard/view/dashboard_view.dart';
import 'package:student_info_system/features/departments/view/department_view.dart';
import 'package:student_info_system/features/importData(CSV)/view/import_data.dart';
import 'package:student_info_system/features/settings/view/settings_view.dart';
import 'package:student_info_system/features/students/view/student_view.dart';

class NavigationRouter extends StatelessWidget {
  final SidebarXController controller;

  // ignore: unused_element_parameter
  const NavigationRouter({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return DashboardView();
          case 1:
            return StudentView();
          case 2:
            return CoursesView();
          case 3:
            return DepartmentView();

          case 4:
            return ImportData();
          case 5:
            return StorageSettings();
          case 6:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            });
            return SizedBox.shrink();
          default:
            return Center(
              child: Text(
                'Page not found',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 24.sp),
              ),
            );
        }
      },
    );
  }
}
