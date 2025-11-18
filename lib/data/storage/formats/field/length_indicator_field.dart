

import '../field_format.dart';

class LengthIndicatorField implements FieldFormat {
  @override
  String encode(String field) => "${field.length}#$field";

  @override
  String decode(String raw) {
    final parts = raw.split('#');
    return parts.length > 1 ? parts.sublist(1).join('#') : raw;
  }
}
