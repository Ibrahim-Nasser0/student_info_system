import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/data/models/course_model.dart';
import 'package:student_info_system/data/models/department_model.dart';
import 'package:student_info_system/data/models/student_model.dart';
import 'package:student_info_system/data/repository/department_repository.dart';
import 'package:student_info_system/features/departments/view/widgets/department_card.dart';
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
                      // استخدم الحالة الصحيحة بعد جلب التفاصيل
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
                  // استخدم البيانات الموجودة مسبقًا بدلاً من استدعاء Cubit
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

void showDepartmentDetailsPopup(
  BuildContext context,
  String deptName,
  List<StudentModel> students,
  List<CourseModel> courses,
) {
  showDialog(
    context: context,
    builder: (ctx) {
      return DefaultTabController(
        length: 2,
        child: AlertDialog(
          backgroundColor: AppColors.secondaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
            child: Text(
              deptName,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.all(16),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                TabBar(
                  labelColor: AppColors.textPrimary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.textPrimary,
                  tabs: const [
                    Tab(text: "Students"),
                    Tab(text: "Courses"),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Students tab
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              "Total Students: ${students.length}",
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(color: AppColors.textSecondary),
                          Expanded(
                            child: students.isNotEmpty
                                ? ListView.separated(
                                    itemCount: students.length,
                                    separatorBuilder: (_, __) => const Divider(
                                      color: AppColors.textSecondary,
                                    ),
                                    itemBuilder: (context, index) {
                                      final s = students[index];
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: AppColors.accentBlue,
                                          child: Text(
                                            s.id.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          s.name,
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text(
                                      "No Students",
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),

                      // Courses tab
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              "Total Courses: ${courses.length}",
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(color: AppColors.textSecondary),
                          Expanded(
                            child: courses.isNotEmpty
                                ? ListView.separated(
                                    itemCount: courses.length,
                                    separatorBuilder: (_, __) => const Divider(
                                      color: AppColors.textSecondary,
                                    ),
                                    itemBuilder: (context, index) {
                                      final c = courses[index];
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: AppColors.accentBlue,
                                          child: Text(
                                            c.code,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          c.name,
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text(
                                      "No Courses",
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.accentBlue,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      );
    },
  );
}
