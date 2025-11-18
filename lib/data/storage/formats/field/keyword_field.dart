import '../field_format.dart';

class KeywordField implements FieldFormat {
  final String key;
  KeywordField(this.key);

  @override
  String encode(String field) => "$key=$field;";

  @override
  String decode(String raw) {
    return raw.split("=").last.replaceAll(";", "");
  }
}
