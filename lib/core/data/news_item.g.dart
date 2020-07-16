// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsItem _$NewsItemFromJson(Map<String, dynamic> json) {
  return NewsItem(
    id: json['id'] as int,
    deleted: json['deleted'] as bool,
    type: _$enumDecodeNullable(_$NewsItemTypesEnumMap, json['type']),
    by: json['by'] as String,
    time: const UnixTime().fromJson(json['time'] as int),
    score: json['score'] as int,
    title: json['title'] as String,
    text: json['text'] as String,
  );
}

Map<String, dynamic> _$NewsItemToJson(NewsItem instance) => <String, dynamic>{
      'id': instance.id,
      'deleted': instance.deleted,
      'type': _$NewsItemTypesEnumMap[instance.type],
      'by': instance.by,
      'time': const UnixTime().toJson(instance.time),
      'score': instance.score,
      'title': instance.title,
      'text': instance.text,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$NewsItemTypesEnumMap = {
  NewsItemTypes.job: 'job',
  NewsItemTypes.story: 'story',
  NewsItemTypes.comment: 'comment',
  NewsItemTypes.poll: 'poll',
  NewsItemTypes.pollopt: 'pollopt',
};
