import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:student_info_system/core/constant/app_colors.dart';

class SidebarMenu extends StatelessWidget {
  final SidebarXController controller;

  const SidebarMenu({super.key, required this.controller});

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
