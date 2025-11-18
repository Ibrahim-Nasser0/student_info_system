import 'package:flutter/material.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:flutter_python_bridge/flutter_python_bridge.dart';

final pyBridge = PythonBridge();

class StudentDataTable extends StatelessWidget {
  const StudentDataTable({super.key});

  final List<Map<String, dynamic>> students = const [
    {
      'id': 101,
      'name': 'Ibrahim',
      'Department': 'CS',
      'gpa': 3.8,
      'status': 'Active',
    },
    {
      'id': 102,
      'name': 'Ahmed',
      'Department': 'CS',
      'gpa': 1.9,
      'status': 'View',
    },
    {
      'id': 103,
      'name': 'Amr',
      'Department': 'CS',
      'gpa': 3.2,
      'status': 'Active',
    },
    {
      'id': 104,
      'name': 'Abdullah',
      'Department': 'زارعه قسم خراطيم',
      'gpa': 9.4,
      'status': 'Active',
    },
    {
      'id': 105,
      'name': 'Mohamed',
      'Department': 'CS',
      'gpa': 2.9,
      'status': 'Active',
    },
    {
      'id': 109,
      'name': 'Mo Magdy',
      'Department': 'CS',
      'gpa': 3.9,
      'status': 'Active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1000,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(
            AppColors.secondaryBackground,
          ),

          showBottomBorder: true,

          border: TableBorder(
            horizontalInside: const BorderSide(
              color: AppColors.divider,
              width: 1,
            ),
            top: const BorderSide(color: AppColors.divider, width: 1),
            bottom: const BorderSide(color: AppColors.divider, width: 1),
          ),

          columns: [
            DataColumn(
              label: Text(
                'ID',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Name',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Department',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'GPA',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              numeric: true,
            ),
            DataColumn(
              label: Text(
                'Status',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],

          rows: students.map((student) {
            Color gpaColor = student['gpa'] >= 2.5 ? Colors.green : Colors.red;

            return DataRow(
              color: MaterialStateProperty.all(AppColors.textPrimary),
              cells: [
                DataCell(
                  Text(
                    student['id'].toString(),
                    style: const TextStyle(
                      color: AppColors.backgroundDark,
                      fontSize: 18,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    student['name'],
                    style: const TextStyle(
                      color: AppColors.backgroundDark,
                      fontSize: 18,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    student['Department'],
                    style: const TextStyle(
                      color: AppColors.backgroundDark,
                      fontSize: 18,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    student['gpa'].toString(),
                    style: TextStyle(
                      color: gpaColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    student['status'],
                    style: const TextStyle(
                      color: AppColors.backgroundDark,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
