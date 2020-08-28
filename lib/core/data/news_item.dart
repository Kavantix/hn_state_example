import 'package:json_annotation/json_annotation.dart';

import 'converters.dart';

part 'news_item.g.dart';

class Test {}

enum NewsItemTypes {
  job,
  story,
  comment,
  poll,
  pollopt,
}

@JsonSerializable()
@UnixTime()
class NewsItem {
  final int id;
  final bool deleted;
  final NewsItemTypes type;
  final String by;
  final DateTime time;
  final int score;
  final String title;
  final String text;

  NewsItem({
    this.id,
    this.deleted,
    this.type,
    this.by,
    this.time,
    this.score,
    this.title,
    this.text,
  });

  static NewsItem fromJson(Map<String, dynamic> json) => _$NewsItemFromJson(json);
  Map<String, dynamic> toJson() => _$NewsItemToJson(this);
}
