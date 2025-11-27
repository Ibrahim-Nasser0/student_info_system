import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/data/repository/department_repository.dart';
import 'package:student_info_system/features/departments/view/widgets/department_grid.dart';
import 'package:student_info_system/features/departments/view/widgets/show_department_details.dart';
import 'package:student_info_system/features/departments/viewModel/cubit/department_cubit.dart';
import 'package:student_info_system/features/departments/viewModel/cubit/department_state.dart';

class DepartmentView extends StatelessWidget {
  const DepartmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DepartmentCubit(DepartmentRepository())
            ..loadAllDepartmentDetails(), // جلب كل الأقسام مع التفاصيل
      child: BlocListener<DepartmentCubit, DepartmentState>(
        listener: (context, state) {
          if (state is DepartmentDetailsLoaded) {
            showDepartmentDetailsPopup(
              context,
              state.departmentName,
              state.students,
              state.courses,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(45),
              Text(
                'Departments',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 38.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(20),

              Expanded(
                child: BlocBuilder<DepartmentCubit, DepartmentState>(
                  builder: (context, state) {
                    if (state is DepartmentLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (state is DepartmentDetailsSummaryLoaded) {
             
                      final departments = state.departments;

                      return DepartmentGrid(departments: departments);
                    }

                    return const Center(child: Text('No Departments'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
