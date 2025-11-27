import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:student_info_system/core/constant/app_colors.dart';

class StorageSettings extends StatefulWidget {
  const StorageSettings({super.key});

  @override
  State<StorageSettings> createState() => _StorageSettingsState();
}

class _StorageSettingsState extends State<StorageSettings> {
  String _recordStorageType = 'Fixed-Length';
  String _fieldStorageFormat = 'Fixed-Length';

  final List<String> recordStorageOptions = [
    'Delimited',
    'Fixed-Length',
    'Number of Fields',
    'Length-Indicator',
  ];

  final List<String> fieldFormatOptions = [
    'Delimited',
    'Fixed-Length',
    'Keyword',
    'Length-Indicator',
  ];

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saved is Successfuly'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.backgroundDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            CustomDropdownMenu(
              title: 'Recor Storage Format:',
              selectedValue: _recordStorageType,
              options: recordStorageOptions,
              onChanged: (newValue) {
                setState(() {
                  _recordStorageType = newValue!;
                });
              },
            ),

            CustomDropdownMenu(
              title: 'Field Storage Format:',
              selectedValue: _fieldStorageFormat,
              options: fieldFormatOptions,
              onChanged: (newValue) {
                setState(() {
                  _fieldStorageFormat = newValue!;
                });
              },
            ),

            Gap(30),

            ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save Settings',
                style: TextStyle(fontSize: 18, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropdownMenu extends StatelessWidget {
  const CustomDropdownMenu({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
  });

  final String title;
  final String selectedValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              fillColor: AppColors.backgroundDark,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            value: selectedValue,
            dropdownColor: AppColors.secondaryBackground,
            style: const TextStyle(color: AppColors.textPrimary),
            isExpanded: true,
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
