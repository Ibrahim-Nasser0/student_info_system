import 'package:flutter/material.dart';
import 'package:student_info_system/features/auth/view/login_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      child: MaterialApp(
        home: const LoginView(),
        debugShowCheckedModeBanner: false,
        
      ),
    );
  }
}
