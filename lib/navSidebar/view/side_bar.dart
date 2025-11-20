import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_info_system/features/auth/view/login_view.dart';
import 'package:student_info_system/features/courses/view/courses_view.dart';
import 'package:student_info_system/features/departments/view/department_view.dart';
import 'package:student_info_system/features/dashboard/view/dashboard_view.dart';
import 'package:student_info_system/features/importData(CSV)/view/import_data.dart';
import 'package:student_info_system/features/settings/view/settings_view.dart';
import 'package:student_info_system/features/students/view/student_view.dart';

class SideBar extends StatelessWidget {
  SideBar({super.key});

  final SidebarXController _controller = SidebarXController(
    selectedIndex: 0,
    extended: true,
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      key: _scaffoldKey,
      appBar: isSmallScreen
          ? AppBar(
              backgroundColor: AppColors.secondaryBackground,
              title: Text(_getTitleByIndex(_controller.selectedIndex)),
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            )
          : null,
      drawer: isSmallScreen ? AppSidebar(controller: _controller) : null,
      body: Row(
        children: [
          if (!isSmallScreen) AppSidebar(controller: _controller),
          Expanded(child: _NavigationContent(controller: _controller)),
        ],
      ),
    );
  }
}

class AppSidebar extends StatelessWidget {
  final SidebarXController controller;

  const AppSidebar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: AppColors.hover,
        textStyle: TextStyle(color: AppColors.textSecondary),
        selectedTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.secondaryBackground),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              AppColors.accentBlue.withOpacity(0.3),
              AppColors.secondaryBackground,
            ],
          ),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 20)],
        ),
        iconTheme: IconThemeData(color: AppColors.textSecondary, size: 20),
        selectedIconTheme: IconThemeData(color: AppColors.accentBlue, size: 20),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(color: AppColors.secondaryBackground),
      ),
      footerDivider: Divider(color: AppColors.textSecondary.withOpacity(0.3)),
      headerBuilder: (context, extended) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: CircleAvatar(
            radius: 40.r,
            backgroundImage: AssetImage('assets/images/avatar.png'),
            backgroundColor: AppColors.accentBlue.withOpacity(0.3),
          ),
        );
      },
      items: [
        SidebarXItem(icon: Icons.home, label: ' Dashboard'),
        SidebarXItem(icon: Icons.people, label: ' Students'),
        SidebarXItem(icon: Icons.book, label: ' Courses'),
        SidebarXItem(icon: Icons.account_balance, label: ' Departments'),
        SidebarXItem(icon: Icons.bar_chart, label: 'Import Data (CSV)'),
        SidebarXItem(icon: Icons.settings, label: ' Settings'),
        SidebarXItem(icon: Icons.logout, label: ' Logout'),
      ],
    );
  }
}

class _NavigationContent extends StatelessWidget {
  final SidebarXController controller;

  // ignore: unused_element_parameter
  const _NavigationContent({super.key, required this.controller});

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

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Dashboard';
    case 1:
      return 'Students';
    case 2:
      return 'Courses';
    case 3:
      return 'Departments';
    case 4:
      return 'Import Data (CSV)';
    case 5:
      return 'Settings';
    case 6:
      return 'Logout';
    default:
      return 'Not Found';
  }
}
