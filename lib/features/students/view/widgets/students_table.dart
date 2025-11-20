import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/features/students/models/student_model.dart';
import 'package:student_info_system/features/students/view/student_view.dart';

class StudentTable extends StatelessWidget {
  StudentTable({super.key});
  final List<StudentModel> students = [
    StudentModel(
      id: 1,
      name: 'Ibrahim Nasser',
      gpa: 3,
      department: 'Computer Science',
      level: 'three',
    ),
    StudentModel(
      id: 2,
      name: 'Sara Ahmed',
      gpa: 3,
      department: 'Information Systems',
      level: 'three',
    ),
    StudentModel(
      id: 3,
      name: 'Omar Hassan',
      gpa: 4,
      department: 'Software Engineering',
      level: 'four',
    ),
    StudentModel(
      id: 4,
      name: 'Hassan',
      gpa: 4,
      department: 'Software Engineering',
      level: 'four',
    ),
    StudentModel(
      id: 1,
      name: 'Ibrahim Nasser',
      gpa: 3,
      department: 'Computer Science',
      level: 'three',
    ),
    StudentModel(
      id: 2,
      name: 'Sara Ahmed',
      gpa: 3,
      department: 'Information Systems',
      level: 'three',
    ),
    StudentModel(
      id: 3,
      name: 'Omar Hassan',
      gpa: 4,
      department: 'Software Engineering',
      level: 'four',
    ),
    StudentModel(
      id: 4,
      name: 'Hassan',
      gpa: 4,
      department: 'Software Engineering',
      level: 'four',
    ),
    StudentModel(
      id: 1,
      name: 'Ibrahim Nasser',
      gpa: 3,
      department: 'Computer Science',
      level: 'three',
    ),
    StudentModel(
      id: 2,
      name: 'Sara Ahmed',
      gpa: 3,
      department: 'Information Systems',
      level: 'three',
    ),
    StudentModel(
      id: 3,
      name: 'Omar Hassan',
      gpa: 4,
      department: 'Software Engineering',
      level: 'four',
    ),
    StudentModel(
      id: 4,
      name: 'Hassan',
      gpa: 4,
      department: 'Software Engineering',
      level: 'four',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: 600.h,
      decoration: BoxDecoration(
        color: AppColors.shadow,
        borderRadius: BorderRadius.circular(10.r),
      ),

      child: Column(
        children: [
          StudentHeadingDataRow(),
          Gap(10),

          Expanded(
            child: AnimationLimiter(
              child: ListView.separated(
                physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: students.length,
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
                        child: StudentDataRow(student: students[index]),
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
