import 'package:flutter/material.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/features/auth/view/widgets/footer.dart';
import 'package:student_info_system/features/auth/view/widgets/login_card.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(children: const [Spacer(), LoginCard(), Spacer(), Footer()]),
    );
  }
}
