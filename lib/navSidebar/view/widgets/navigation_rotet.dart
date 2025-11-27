import 'package:flutter/material.dart';
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

  const NavigationRouter({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return const DashboardView();
          case 1:
            return const StudentView();
          case 2:
            return const CoursesView();
          case 3:
            return const DepartmentView();
          case 4:
            return const ImportData();
          case 5:
            return const StorageSettings();
          case 6:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            });
            return const SizedBox.shrink();
          default:
            return const Center(
              child: Text(
                'Page not found',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 24),
              ),
            );
        }
      },
    );
  }
}
