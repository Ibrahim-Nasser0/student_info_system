import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/navSidebar/view/widgets/navigation_rotet.dart';
import 'package:student_info_system/navSidebar/view/widgets/side_bar_menu.dart';

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
      drawer: isSmallScreen ? SidebarMenu(controller: _controller) : null,
      body: Row(
        children: [
          if (!isSmallScreen) SidebarMenu(controller: _controller),
          Expanded(child: NavigationRouter(controller: _controller)),
        ],
      ),
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
