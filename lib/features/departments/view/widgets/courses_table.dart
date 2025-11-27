import 'package:flutter/material.dart';
import 'package:student_info_system/core/constant/app_colors.dart';

class CoursesDataTable extends StatelessWidget {
  const CoursesDataTable({super.key});

  final List<Map<String, dynamic>> students = const [
    {
      'Code': 'MT101',
      'name': 'Math 1',
      'Creadit Hours': 3,
      'Enrolled Students': 80,
      'Department': 'CS',
    },
    {
      'Code': 'MT104',
      'name': 'Math 2',
      'Creadit Hours': 3,
      'Enrolled Students': 90,
      'Department': 'CS ',
    },
    {
      'Code': 'MT172',
      'name': 'Database',
      'Creadit Hours': 3,
      'Enrolled Students': 40,
      'Department': 'CS',
    },
    {
      'Code': 'MT101',
      'name': 'Data Structuer',
      'Creadit Hours': 3,
      'Enrolled Students': 30,
      'Department': 'CS',
    },
    {
      'Code': 'MT190',
      'name': 'OOP',
      'Creadit Hours': 3,
      'Enrolled Students': 80,
      'Department': 'CS',
    },
    {
      'Code': 'MT101',
      'name': 'Math 1',
      'Creadit Hours': 3,
      'Enrolled Students': 80,
      'Department': 'CS',
    },
    {
      'Code': 'MT104',
      'name': 'Math 2',
      'Creadit Hours': 3,
      'Enrolled Students': 90,
      'Department': 'CS ',
    },
    {
      'Code': 'MT172',
      'name': 'Database',
      'Creadit Hours': 3,
      'Enrolled Students': 40,
      'Department': 'CS',
    },
    {
      'Code': 'MT101',
      'name': 'Data Structuer',
      'Creadit Hours': 3,
      'Enrolled Students': 30,
      'Department': 'CS',
    },
    {
      'Code': 'MT190',
      'name': 'OOP',
      'Creadit Hours': 3,
      'Enrolled Students': 80,
      'Department': 'CS',
    },
    {
      'Code': 'MT101',
      'name': 'Math 1',
      'Creadit Hours': 3,
      'Enrolled Students': 80,
      'Department': 'CS',
    },
    {
      'Code': 'MT104',
      'name': 'Math 2',
      'Creadit Hours': 3,
      'Enrolled Students': 90,
      'Department': 'CS ',
    },
    {
      'Code': 'MT172',
      'name': 'Database',
      'Creadit Hours': 3,
      'Enrolled Students': 40,
      'Department': 'CS',
    },
    {
      'Code': 'MT101',
      'name': 'Data Structuer',
      'Creadit Hours': 3,
      'Enrolled Students': 30,
      'Department': 'CS',
    },
    {
      'Code': 'MT190',
      'name': 'OOP',
      'Creadit Hours': 3,
      'Enrolled Students': 80,
      'Department': 'CS',
    },
    {
      'Code': 'MT101',
      'name': 'Math 1',
      'Creadit Hours': 3,
      'Enrolled Students': 80,
      'Department': 'CS',
    },
    {
      'Code': 'MT104',
      'name': 'Math 2',
      'Creadit Hours': 3,
      'Enrolled Students': 90,
      'Department': 'CS ',
    },
    {
      'Code': 'MT172',
      'name': 'Database',
      'Creadit Hours': 3,
      'Enrolled Students': 40,
      'Department': 'CS',
    },
    {
      'Code': 'MT101',
      'name': 'Data Structuer',
      'Creadit Hours': 3,
      'Enrolled Students': 30,
      'Department': 'CS',
    },
    {
      'Code': 'MT190',
      'name': 'OOP',
      'Creadit Hours': 3,
      'Enrolled Students': 80,
      'Department': 'CS',
    },
    {
      'Code': 'MT101',
      'name': 'Math 1',
      'Creadit Hours': 3,
      'Enrolled Students': 80,
      'Department': 'CS',
    },
    {
      'Code': 'MT104',
      'name': 'Math 2',
      'Creadit Hours': 3,
      'Enrolled Students': 90,
      'Department': 'CS ',
    },
    {
      'Code': 'MT172',
      'name': 'Database',
      'Creadit Hours': 3,
      'Enrolled Students': 40,
      'Department': 'CS',
    },
    {
      'Code': 'MT101',
      'name': 'Data Structuer',
      'Creadit Hours': 3,
      'Enrolled Students': 30,
      'Department': 'CS',
    },
    {
      'Code': 'MT190',
      'name': 'OOP',
      'Creadit Hours': 3,
      'Enrolled Students': 80,
      'Department': 'CS',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
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
                'Code',
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
                'Creadit Hours',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Enrolled Students',
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
                'Department',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],

          rows: students.map((student) {
            return DataRow(
              color: MaterialStateProperty.all(AppColors.textPrimary),
              cells: [
                DataCell(
                  Text(
                    student['Code'],
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
                    student['Creadit Hours'].toString(),
                    style: const TextStyle(
                      color: AppColors.backgroundDark,
                      fontSize: 18,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    student['Enrolled Students'].toString(),
                    style: TextStyle(
                      color: AppColors.backgroundDark,
                      fontWeight: FontWeight.bold,
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
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
