abstract class RecordFormat {
  RecordFormat(List<String> split);

  List<Record> decode(String raw);
  String encode(List<Record> records);
}

class Record {
  final List<String> fields;
  Record(this.fields);

  String serialize(String delimiter) {
    return fields.join(delimiter);
  }
}
