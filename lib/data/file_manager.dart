import 'dart:io';
import 'dart:convert';

class FileManager {
  final String basePath;

  FileManager({this.basePath = 'files'}) {
    Directory(basePath).createSync(recursive: true);
  }

  Future<void> write(String filename, String data) async {
    final file = File('$basePath/$filename'); // هنا
    await file.writeAsString(data, encoding: utf8);
  }

  Future<String> read(String filename) async {
    final file = File('$basePath/$filename'); // هنا
    return await file.readAsString(encoding: utf8);
  }

  Future<void> append(String filename, String data) async {
    final file = File('$basePath/$filename'); // هنا
    await file.writeAsString(data, mode: FileMode.append, encoding: utf8);
  }

  bool exists(String filename) {
    return File('$basePath/$filename').existsSync(); // هنا
  }

  Future<void> delete(String filename) async {
    final file = File('$basePath/$filename'); // هنا
    if (await file.exists()) {
      await file.delete();
    }
  }
}
