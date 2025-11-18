import 'dart:io';

class FileUtils {
  static Future<List<String>> readLines(String path) async {
    final file = File(path);
    if (!await file.exists()) return [];
    return file.readAsLines();
  }

  static Future<void> writeLines(String path, List<String> lines) async {
    final file = File(path);
    await file.writeAsString(lines.join('\n'));
  }
}
