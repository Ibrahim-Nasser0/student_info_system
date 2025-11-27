import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/features/dashboard/models/progress_model.dart';

class ProgressBar extends StatelessWidget {
  ProgressBar({super.key, required this.progressModel, required this.color});

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  final ProgressModel progressModel;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return DashedCircularProgressBar.aspectRatio(
      aspectRatio: 0.78,
      valueNotifier: _valueNotifier,
      progress: progressModel.progress,
      maxProgress: progressModel.maxProgress,
      startAngle: 225,
      sweepAngle: 270,
      foregroundColor: color,
      backgroundColor: const Color(0xffeeeeee),
      foregroundStrokeWidth: 15,
      backgroundStrokeWidth: 15,
      animation: true,
      seekSize: 6,
      seekColor: const Color(0xffeeeeee),
      child: Center(
        child: ValueListenableBuilder(
          valueListenable: _valueNotifier,
          builder: (_, double value, __) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${((value.toInt() / progressModel.maxProgress) * 100).toInt()}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 50.sp,
                ),
              ),
              Text(
                progressModel.title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w400,
                  fontSize: 25.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
