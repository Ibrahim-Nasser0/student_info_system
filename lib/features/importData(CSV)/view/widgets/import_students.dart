import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/features/students/viewModel/cubit/student_cubit.dart';

Future<void> pickAndImportStudents(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
  );

  if (result != null && result.files.single.path != null) {
    final filePath = result.files.single.path!;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting Student CSV import...'),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      await context.read<StudentCubit>().importStudents(filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Students imported successfully and list refreshed!'),
          backgroundColor: AppColors.accentBlue,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Student Import Failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
