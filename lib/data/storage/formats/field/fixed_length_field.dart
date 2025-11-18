

import '../field_format.dart';

class FixedLengthField implements FieldFormat {
  final int length;
  FixedLengthField(this.length);

  @override
  String encode(String field) {
    if (field.length > length) {
      return field.substring(0, length);
    }
    return field.padRight(length, ' ');
  }

  @override
  String decode(String raw) => raw.trimRight();
}
