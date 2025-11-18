class NumberOfFieldsRecord {

  String encode(List<String> fields) => '${fields.length}#${fields.join(',')}';

  List<String> decode(String record) {
    final parts = record.split('@');
    if (parts.length < 2) return [];
    return parts[1].split(',');
  }
}
