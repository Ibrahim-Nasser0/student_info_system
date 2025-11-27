import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';
import 'package:student_info_system/core/shared/custom_botton.dart';
import 'package:student_info_system/core/shared/custom_text_field.dart';
import 'package:student_info_system/data/models/course_model.dart';
import 'package:student_info_system/features/courses/viewModel/cubit/courses_cubit.dart';
import 'package:student_info_system/features/students/models/searching_methods_model.dart';
import 'package:student_info_system/core/shared/custom_search_botton.dart';

// ==========================================================
// 1. SearchingCoursesMethods (Stateful - Manages Search Logic)
// ==========================================================

class SearchingCoursesMethods extends StatefulWidget {
  const SearchingCoursesMethods({super.key});

  @override
  State<SearchingCoursesMethods> createState() =>
      _SearchingCoursesMethodsState();
}

class _SearchingCoursesMethodsState extends State<SearchingCoursesMethods> {
  final TextEditingController _searchController = TextEditingController();

  // 0: Code, 1: Name, 2: Creadit Hours, 3: Enrolled Students, 4: Department
  int _selectedSearchIndex = 0;

  final List<SearchingMethodsModel> searchingMethods = [
    SearchingMethodsModel(text: 'Code', index: 0),
    SearchingMethodsModel(text: 'Name', index: 1),
    SearchingMethodsModel(text: 'Credit Hours', index: 2),
    SearchingMethodsModel(text: 'Enrolled Students', index: 3),
    SearchingMethodsModel(text: 'Department', index: 4),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // دالة البحث التي تقرر أي ميثود تستدعي بناءً على الاندكس
  void _performSearch(String query) {
    final cubit = context.read<CourseCubit>();

    if (query.isEmpty) {
      cubit.clearSearch();
      return;
    }

    // هنا يجب إضافة الدوال المطلوبة في الـ Cubit (مثل searchByName, searchByDepartment)
    // حاليًا، الـ Cubit يحتوي فقط على searchByCode. سنقوم باستدعاء loadCourses
    // إذا لم يكن البحث بالكود أو إذا كان النص رقمًا غير صحيح للحقول الرقمية.
    // **ملاحظة:** إذا أردت البحث بالحقول الأخرى، يجب إضافة دوال في CourseRepository و CourseCubit.

    switch (_selectedSearchIndex) {
      case 0: // Code
        cubit.searchByCode(query);
        break;
      case 1: // Name
        // cubit.searchByName(query);

        // cubit.loadCourses();
        break;
      case 2: // Credit Hours
        // final hours = int.tryParse(query);
        // if (hours != null) { cubit.searchByCreditHours(hours); }
        // cubit.loadCourses();
        break;
      default:
        // إذا كان البحث غير بالكود، نترك الـ Cubit يعرض القائمة الكاملة مؤقتاً
        cubit.loadCourses();
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
                // ✅ ربط الـ TextField بالـ state والـ logic
                hintText:
                    'Search by ${searchingMethods[_selectedSearchIndex].text}...',
                controller: _searchController,
                prefixIcon: const Icon(Icons.search),
                onChanged: (value) => _performSearch(value),
              ),
            ),
            const Gap(20),
            CustomButton(
              tittle: 'Add Course',
              onPressed: () => showAddOrEditCoursePopup(context),
            ),
            const Gap(10),
            CustomButton(
              tittle: 'Delete All',
              onPressed: () => context.read<CourseCubit>().deleteAllCourses(),
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
        // ✅ استخدام SearchingRow كـ controlled widget
        SearchingRow(
          searchingMethods: searchingMethods,
          selectedIndex: _selectedSearchIndex,
          onMethodSelected: (index) {
            setState(() {
              _selectedSearchIndex = index;
            });
            // إعادة البحث فوراً عند تغيير الطريقة
            if (_searchController.text.isNotEmpty) {
              _performSearch(_searchController.text);
            }
          },
        ),
      ],
    );
  }
}

// ==========================================================
// 2. SearchRow (Stateless - Controlled by Parent)
// ==========================================================

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
            // ✅ استدعاء الـ callback
            onTap: () => onMethodSelected(index),
            isSelected: selectedIndex == index,
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// 3. showAddOrEditCoursePopup (No Change Needed, Logic is Sound)
// ==========================================================

void showAddOrEditCoursePopup(BuildContext context, {CourseModel? course}) {
  // نحتفظ بـ Cubit الحالي لاستخدامه داخل الديالوج
  final cubit = context.read<CourseCubit>();

  // وحدات التحكم (Controllers)
  final codeController = TextEditingController(text: course?.code ?? '');
  final nameController = TextEditingController(text: course?.name ?? '');
  final hoursController = TextEditingController(
    text: course != null ? course.creditHours.toString() : '',
  );
  final studentsController = TextEditingController(
    text: course != null ? course.enrolledStudents.toString() : '',
  );
  final instructorController = TextEditingController(
    text: course?.instructor ?? '',
  );
  final departmentController = TextEditingController(
    text: course?.department ?? '',
  );

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.secondaryBackground,
        title: Text(
          course == null ? 'Add New Course' : 'Edit Course',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                hintText: 'Code (e.g., CS301)',
                controller: codeController,
                readOnly: course != null,
                width: double.infinity,
              ),
              const Gap(10),
              CustomTextField(
                hintText: 'Course Name',
                controller: nameController,
                width: double.infinity,
              ),
              const Gap(10),
              CustomTextField(
                hintText: 'Credit Hours',
                controller: hoursController,
                keyboardType: TextInputType.number,
                width: double.infinity,
              ),
              const Gap(10),
              CustomTextField(
                hintText: 'Enrolled Students (Optional)',
                controller: studentsController,
                keyboardType: TextInputType.number,
                width: double.infinity,
              ),
              const Gap(10),
              CustomTextField(
                hintText: 'Instructor Name',
                controller: instructorController,
                width: double.infinity,
              ),
              const Gap(10),
              CustomTextField(
                hintText: 'Department',
                controller: departmentController,
                width: double.infinity,
              ),
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
            tittle: course == null ? 'Add' : 'Update',
            onPressed: () {
              final code = codeController.text.trim();
              final name = nameController.text.trim();
              final hoursText = hoursController.text.trim();
              final studentsText = studentsController.text.trim();
              final instructor = instructorController.text.trim();
              final department = departmentController.text.trim();

              if (code.isEmpty ||
                  name.isEmpty ||
                  hoursText.isEmpty ||
                  department.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Please fill Code, Name, Credit Hours, and Department.",
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final creditHours = int.tryParse(hoursText);
              final enrolledStudents = int.tryParse(
                studentsText.isEmpty ? '0' : studentsText,
              );

              if (creditHours == null ||
                  enrolledStudents == null ||
                  creditHours <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Credit Hours must be a valid number greater than 0.",
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final courseData = CourseModel(
                code: code,
                name: name,
                creditHours: creditHours,
                enrolledStudents: enrolledStudents,
                instructor: instructor.isEmpty ? 'N/A' : instructor,
                department: department,
              );

              if (course == null) {
                cubit.addCourse(courseData);
              } else {
                cubit.updateCourse(courseData);
              }

              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}
