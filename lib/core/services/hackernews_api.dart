import 'dart:convert';

import 'package:http/http.dart';
import 'package:hn_state_example/core/data/news_item.dart';

import 'news_api.dart';

class HackernewsApi implements NewsApi {
  final _client = Client();

  static const host = 'https://hacker-news.firebaseio.com/v0';

  @override
  Future<NewsItem> item(int id) async {
    final response = await _client.get('$host/item/$id.json');
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json == null) return null;
    return NewsItem.fromJson(json);
  }

  @override
  Future<List<int>> newStories() async {
    final response = await _client.get('$host/newstories.json');
    return (jsonDecode(response.body) as List<dynamic>).cast<int>();
  }

  @override
  Future<List<int>> topStories() async {
    final response = await _client.get('$host/topstories.json');
    return (jsonDecode(response.body) as List<dynamic>).cast<int>();
  }
}
