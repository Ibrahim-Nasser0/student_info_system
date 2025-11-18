

import '../field_format.dart';

class DelimitedField implements FieldFormat {
  final String delimiter;
  DelimitedField(this.delimiter);

  @override
  String encode(String field) => "$field$delimiter";

  @override
  String decode(String raw) => raw.replaceAll(delimiter, "");
}
