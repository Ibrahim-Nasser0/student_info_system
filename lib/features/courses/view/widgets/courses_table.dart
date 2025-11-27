// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/data/models/course_model.dart';
import 'package:student_info_system/features/courses/view/courses_view.dart';
import 'package:student_info_system/features/courses/viewModel/cubit/courses_cubit.dart';
import 'package:student_info_system/features/courses/viewModel/cubit/courses_state.dart';

class CoursesTable extends StatelessWidget {
  const CoursesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseCubit, CourseState>(
      listener: (context, state) {
        // ✅ إضافة منطق عرض رسالة الخطأ
        if (state is CourseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        // 1. استخراج القائمة وتحديد المصدر
        List<CourseModel> courses = [];
        bool isSearching = false;

        if (state is CourseLoaded) {
          courses = state.courses;
        } else if (state is CourseSearchLoaded) {
          courses = state.results.map((e) => e.course).toList();
          isSearching = true;
        }

        // 2. التعامل مع حالة التحميل
        if (state is CourseLoading) {
          return SizedBox(
            height: 600.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        // 3. التعامل مع حالة عدم وجود بيانات (بعد محاولة التحميل)
        // إذا كانت القائمة فارغة والـ State ليس في حالة التهيئة الأولية أو التحميل
        if (courses.isEmpty && state is! CourseInitial) {
          return SizedBox(
            height: 600.h,
            child: Center(
              child: Text(
                // رسالة واضحة لحالة البحث مقابل حالة القائمة الفارغة
                isSearching ? "No results found." : "No Data Available.",
                style: TextStyle(color: AppColors.textPrimary.withOpacity(0.7)),
              ),
            ),
          );
        }

        // 4. عرض الجدول
        return Container(
          width: double.infinity,
          height: 600.h,
          decoration: BoxDecoration(
            color: AppColors.shadow,
            borderRadius: BorderRadius.circular(10.r),
          ),

          child: Column(
            children: [
              // ⚠️ تأكد أن CourseHeadingDataRow موجود ضمن الـ Imports
              const CourseHeadingDataRow(),
              const Gap(10),

              Expanded(
                child: AnimationLimiter(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    scrollDirection: Axis.vertical,
                    itemCount: courses.length, // ✅ العدد الصحيح
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
                            // ✅ تمرير الكورس الصحيح
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
      },
    );
  }
}
