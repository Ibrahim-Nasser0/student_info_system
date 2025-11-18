import 'dart:io';

import '../formats/record_format.dart';



class FileMigrator {
  final RecordFormat sourceFormat;
  final RecordFormat targetFormat;

  FileMigrator({required this.sourceFormat, required this.targetFormat});

  Future<void> migrate(String sourcePath, String targetPath) async {
    final raw = await File(sourcePath).readAsString();

    final records = sourceFormat.decode(raw);

    final converted = targetFormat.encode(records);

    await File(targetPath).writeAsString(converted);
  }
}
