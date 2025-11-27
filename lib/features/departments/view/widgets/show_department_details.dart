


import 'package:flutter/material.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/data/models/course_model.dart';
import 'package:student_info_system/data/models/student_model.dart';

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
