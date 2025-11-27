import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/data/models/student_model.dart';
import 'package:student_info_system/features/students/view/student_view.dart';
import 'package:student_info_system/features/students/viewModel/cubit/student_cubit.dart';
import 'package:student_info_system/features/students/viewModel/cubit/student_state.dart';

class StudentTable extends StatelessWidget {
  const StudentTable({super.key});

  @override
  Widget build(BuildContext context) {


    return BlocConsumer<StudentCubit, StudentState>(
      listener: (context, state) {
        if (state is StudentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is StudentLoading) {
          return SizedBox(
            height: 600.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

      
        List<StudentModel> studentsList = [];

        if (state is StudentLoaded) {
          studentsList = state.students;
        } else if (state is StudentSearchLoaded) {
          studentsList = state.results.map((e) => e.student).toList();
        }

        if (studentsList.isEmpty && state is! StudentInitial) {
          return SizedBox(
            height: 600.h,
            child: Center(child: Text("Not Data Avilable")),
          );
        }

        return Container(
          width: double.infinity,
          height: 600.h,
          decoration: BoxDecoration(
            color: AppColors.shadow, // تأكد أن AppColors معرف لديك
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              const StudentHeadingDataRow(),
              const Gap(10),
              Expanded(
                child: AnimationLimiter(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                   
                    itemCount: studentsList.length,
                    itemBuilder: (BuildContext c, int index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        delay: const Duration(milliseconds: 100),
                        child: SlideAnimation(
                          duration: const Duration(milliseconds: 2500),
                          curve: Curves.fastLinearToSlowEaseIn,
                          horizontalOffset: 30,
                          verticalOffset: 300.0,
                          child: FlipAnimation(
                            duration: const Duration(milliseconds: 3000),
                            curve: Curves.fastLinearToSlowEaseIn,
                            flipAxis: FlipAxis.y,
                       
                            child: StudentDataRow(student: studentsList[index]),
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
      },
    );
  }
}
