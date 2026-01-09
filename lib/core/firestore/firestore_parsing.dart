int readInt(Map<String, dynamic> json, String key, {int fallback = 0}) {
  final value = json[key];

  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;

  return fallback;
}

bool readBool(Map<String, dynamic> json, String key,
    {bool fallback = false}) {
  final value = json[key];
  if (value is bool) return value;
  return fallback;
}

String readString(Map<String, dynamic> json, String key,
    {String fallback = ''}) {
  final value = json[key];
  if (value is String) return value;
  return fallback;
}

int? readNullableInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is int) return value;
  return null;
}
