import 'package:hn_state_example/core/data/news_item.dart';

abstract class NewsApi {
  Future<List<int>> newStories();
  Future<List<int>> topStories();
  Future<NewsItem> item(int id);
}
