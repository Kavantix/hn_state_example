import 'package:json_annotation/json_annotation.dart';

class UnixTime implements JsonConverter<DateTime, int> {
  const UnixTime();

  @override
  DateTime fromJson(int value) {
    if (value == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(value * 1000);
  }

  @override
  int toJson(DateTime value) {
    if (value == null) return null;
    return value.millisecondsSinceEpoch ~/ 1000;
  }
}
