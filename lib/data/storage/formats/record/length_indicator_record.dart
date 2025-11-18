import '../record_format.dart';

class LengthIndicatorRecordFormat implements RecordFormat {
  @override
  List<Record> decode(String raw) {
    final lines = raw.split('').where((e) => e.trim().isNotEmpty);
    final records = <Record>[];

    for (var line in lines) {
      final hashIndex = line.indexOf('#');
      final data = line.substring(hashIndex + 1);
      records.add(Record(data.split('|')));
    }

    return records;
  }

  @override
  String encode(List<Record> records) {
    final buffer = StringBuffer();

    for (var r in records) {
      final data = r.fields.join('|');
      buffer.write("${data.length}#$data");
    }

    return buffer.toString();
  }
}
