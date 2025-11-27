import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/core/shared/custom_botton.dart';
import 'package:student_info_system/core/shared/custom_text_field.dart';
import 'package:student_info_system/data/models/student_model.dart';
import 'package:student_info_system/features/students/models/searching_methods_model.dart';
import 'package:student_info_system/core/shared/custom_search_botton.dart';
import 'package:student_info_system/features/students/viewModel/cubit/student_cubit.dart';

class SearchingStudentMethods extends StatefulWidget {
  const SearchingStudentMethods({super.key});

  @override
  State<SearchingStudentMethods> createState() =>
      _SearchingStudentMethodsState();
}

class _SearchingStudentMethodsState extends State<SearchingStudentMethods> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedSearchIndex = 0;

  final List<SearchingMethodsModel> searchingMethods = [
    SearchingMethodsModel(text: 'Name', index: 0),
    SearchingMethodsModel(text: 'ID', index: 1),
    SearchingMethodsModel(text: 'Department', index: 2),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      context.read<StudentCubit>().clearSearch();
      return;
    }

    final cubit = context.read<StudentCubit>();

    switch (_selectedSearchIndex) {
      case 0: // Name
        cubit.searchByName(query);
        break;
      case 1: // ID
        final id = int.tryParse(query);
        if (id != null) {
          cubit.searchByID(id);
        }
        break;
      case 2: // Department
        cubit.searchByDepartment(query);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText:
                    'Search by ${searchingMethods[_selectedSearchIndex].text}...',
                controller: _searchController,
                prefixIcon: const Icon(Icons.search),
                // تنفيذ البحث عند الكتابة
                onChanged: (value) => _performSearch(value),
              ),
            ),
            const Gap(20),
            // زر الإضافة
            CustomButton(
              tittle: 'Add Student',
              onPressed: () => showAddOrEditStudentPopup(context),
            ),
            const Gap(10),
            CustomButton(
              tittle: 'Delete All',
              onPressed: () => context.read<StudentCubit>().deleteAllStudents(),
              color: AppColors.accentRed,
              icon: Icons.delete_forever,
            ),
          ],
        ),
        const Gap(10),
        Text(
          'Searching With: ',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 25.sp),
        ),
        const Gap(10),

        SearchingRow(
          searchingMethods: searchingMethods,
          selectedIndex: _selectedSearchIndex,
          onMethodSelected: (index) {
            setState(() {
              _selectedSearchIndex = index;
            });
            // إعادة البحث فوراً عند تغيير الطريقة إذا كان هناك نص مكتوب
            if (_searchController.text.isNotEmpty) {
              _performSearch(_searchController.text);
            }
          },
        ),
      ],
    );
  }
}

class SearchingRow extends StatelessWidget {
  const SearchingRow({
    super.key,
    required this.searchingMethods,
    required this.selectedIndex,
    required this.onMethodSelected,
  });

  final List<SearchingMethodsModel> searchingMethods;
  final int selectedIndex;
  final Function(int) onMethodSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        searchingMethods.length,
        (index) => Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CustomSearchButton(
            searchingMethods: searchingMethods[index],
            onTap: () => onMethodSelected(index),
            isSelected: selectedIndex == index,
          ),
        ),
      ),
    );
  }
}

void showAddOrEditStudentPopup(BuildContext context, {StudentModel? student}) {
  // نحتفظ بالكيوبت الحالي لاستخدامه داخل الديالوج
  final cubit = context.read<StudentCubit>();

  final nameController = TextEditingController(text: student?.name ?? '');
  final idController = TextEditingController(
    text: student != null ? student.id.toString() : '',
  );
  final deptController = TextEditingController(text: student?.department ?? '');
  final gpaController = TextEditingController(
    text: student != null ? student.gpa.toString() : '',
  );
  // إضافة حقول إضافية إذا لزم الأمر مثل الإيميل ورقم الهاتف
  final emailController = TextEditingController(text: student?.email ?? '');
  final phoneController = TextEditingController(
    text: student?.phoneNumber ?? '',
  );
  final levelController = TextEditingController(text: student?.level ?? '');

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.secondaryBackground,
        title: Text(
          student == null ? 'Add New Student' : 'Edit Student',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(hintText: 'Name', controller: nameController),
              const Gap(10),
              // لا تسمح بتعديل الـ ID إذا كنا في وضع التعديل (اختياري)
              CustomTextField(
                hintText: 'ID',
                controller: idController,
                //  readOnly: student != null,
              ),
              const Gap(10),
              CustomTextField(
                hintText: 'Department',
                controller: deptController,
              ),
              const Gap(10),
              CustomTextField(hintText: 'GPA', controller: gpaController),
              const Gap(10),
              // يمكنك إضافة باقي الحقول هنا (Email, Phone, Level)
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
          CustomButton(
            tittle: student == null ? 'Add' : 'Update',
            onPressed: () {
              final name = nameController.text.trim();
              final idText = idController.text.trim();
              final dept = deptController.text.trim();
              final gpaText = gpaController.text.trim();

              if (name.isEmpty || idText.isEmpty || gpaText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please fill all required fields"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final id = int.tryParse(idText);
              final gpa = double.tryParse(gpaText); // GPA عادة double

              if (id == null || gpa == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Invalid ID or GPA format"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              // إنشاء الموديل الجديد
              final newStudentData = StudentModel(
                id: id,
                name: name,
                department: dept,
                gpa: gpa,
                email: emailController.text.trim(),
                phoneNumber: phoneController.text.trim(),
                level: levelController.text.trim().isEmpty
                    ? 'one'
                    : levelController.text.trim(),
              );

              // استدعاء الكيوبت
              if (student == null) {
                // إضافة جديد
                cubit.addStudent(newStudentData);
              } else {
                // تعديل الحالي
                cubit.updateStudent(newStudentData);
              }

              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}
