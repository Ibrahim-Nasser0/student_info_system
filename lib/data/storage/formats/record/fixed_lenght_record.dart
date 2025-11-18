import '../record_format.dart';

class FixedLengthRecordFormat implements RecordFormat {
  final List<int> fieldSizes;
  FixedLengthRecordFormat(this.fieldSizes);

  @override
  List<Record> decode(String raw) {
    // نقسم النص على الأسطر بدل كل حرف
    final lines = raw.split('\n').where((e) => e.trim().isNotEmpty);
    final records = <Record>[];

    for (var line in lines) {
      int index = 0;
      List<String> fields = [];

      for (var size in fieldSizes) {
        if (index + size > line.length) {
          // لو السطر قصير، نكمل الفراغات بدل ما يطلع RangeError
          fields.add(line.substring(index).padRight(size));
          index += size;
        } else {
          fields.add(line.substring(index, index + size).trimRight());
          index += size;
        }
      }

      records.add(Record(fields));
    }

    return records;
  }

  @override
  String encode(List<Record> records) {
    final buffer = StringBuffer();

    for (var record in records) {
      for (int i = 0; i < fieldSizes.length; i++) {
        final size = fieldSizes[i];
        final field = record.fields[i];
        buffer.write(field.padRight(size, ' '));
      }
      buffer.writeln();
    }

    return buffer.toString();
  }
}
