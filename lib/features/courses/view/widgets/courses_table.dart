import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/features/courses/models/course_model.dart';
import 'package:student_info_system/features/courses/view/courses_view.dart';

class CoursesTable extends StatelessWidget {
  CoursesTable({super.key});
  final List<CourseModel> courses = [
    CourseModel(
      name: 'Data Structures',
      code: 'CS201',
      creditHours: 3,
      enrolledStudents: 120,
      instructor: 'Dr. Smith',
      department: 'Computer Science',
    ),
    CourseModel(
      name: 'Database Systems',
      code: 'IS301',
      creditHours: 3,
      enrolledStudents: 80,
      instructor: 'Prof. Johnson',
      department: 'Information Systems',
    ),
    CourseModel(
      name: 'Software Engineering',
      code: 'SE401',
      creditHours: 4,
      enrolledStudents: 60,
      instructor: 'Dr. Lee',
      department: 'Software Engineering',
    ),
    CourseModel(
      name: 'Operating Systems',
      code: 'CS301',
      creditHours: 3,
      enrolledStudents: 90,
      instructor: 'Dr. Brown',
      department: 'Computer Science',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: 680.h,
      decoration: BoxDecoration(
        color: AppColors.shadow,
        borderRadius: BorderRadius.circular(10.r),
      ),

      child: Column(
        children: [
          CourseHeadingDataRow(),
          Gap(10),

          Expanded(
            child: AnimationLimiter(
              child: ListView.separated(
                physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: courses.length,
                itemBuilder: (BuildContext c, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: Duration(milliseconds: 100),

                    child: SlideAnimation(
                      duration: Duration(milliseconds: 2500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      horizontalOffset: 30,
                      verticalOffset: 300.0,
                      child: FlipAnimation(
                        duration: Duration(milliseconds: 3000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        flipAxis: FlipAxis.y,
                        child: CourseDataRow(course: courses[index]),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Gap(15.h);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
