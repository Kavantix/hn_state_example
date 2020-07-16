import 'package:hn_state_example/core/data/news_item.dart';
import 'package:hn_state_example/core/models/likeables/likeable.dart';
import 'package:hn_state_example/core/repositories/index.dart';

import '../base_model.dart';

class LikeableNewsModel extends BaseModel {
  LikeableNewsModel(this._repository);

  final LikeablesRepository _repository;

  NewsItem _newsItem;

  Likeable _likeable;
  Likeable get likeable => _likeable;

  void load(NewsItem newsItem) {
    _newsItem = _newsItem;
    _likeable = _repository.likeableFor(newsItem.id);
  }
}
