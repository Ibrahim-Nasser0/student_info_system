import 'package:flutter/material.dart';
import 'package:student_info_system/core/shared/custom_botton.dart';

class ImportData extends StatelessWidget {
  const ImportData({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text('Import Data from CSV'),

          // Add your import data UI components here
          CustomButton(tittle: 'Import data'),
        ],
      ),
    );
  }
}
