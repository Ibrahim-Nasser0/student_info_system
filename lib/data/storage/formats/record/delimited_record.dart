


import '../record_format.dart';

class DelimitedRecordFormat implements RecordFormat {
    final String delimiter;
    DelimitedRecordFormat(this.delimiter);


    @override
    List<Record> decode(String raw) {
        final lines = raw.split('').where((e) => e.trim().isNotEmpty);
        return lines.map((e) => Record(e.split(delimiter))).toList();

    }


    @override
    String encode(List<Record> records) {
    return records
    .map((r) => r.fields.join(delimiter))
    .join('');
    }
}