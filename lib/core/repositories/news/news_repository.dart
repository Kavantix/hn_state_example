import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hn_state_example/core/data/news_item.dart';
import 'package:hn_state_example/core/services/index.dart';

class UngrowableUnmodifiableListView<T> extends UnmodifiableListView<T> {
  int _length;

  UngrowableUnmodifiableListView(Iterable<T> source)
      : _length = source.length,
        super(source);

  @override
  int get length => min(_length, super.length);
}

class NewsRepository {
  NewsRepository(this._newsApi);

  final NewsApi _newsApi;

  Queue<int> _newStoriesQueue;
  final _newStoriesBacking = <NewsItem>[];
  ValueNotifier<List<NewsItem>> _newStories;
  ValueListenable<List<NewsItem>> get newStories {
    if (_newStories == null) {
      _newStories = ValueNotifier<List<NewsItem>>(null);
      nextNewStoriesPage();
    }
    return _newStories;
  }

  bool _loadingNewStories = false;
  bool get hasNextNewStoriesPage => _newStoriesQueue.isNotEmpty;
  void nextNewStoriesPage() async {
    if (_loadingNewStories || !hasNextNewStoriesPage) return;
    _loadingNewStories = true;
    try {
      if (_newStoriesQueue == null) {
        final ids = await _newsApi.newStories();
        _newStoriesQueue = ListQueue<int>(ids.length);
        _newStoriesQueue.addAll(ids);
      }
      final ids = [
        for (int i = 0; i < 20; i++)
          if (_newStoriesQueue.isNotEmpty) _newStoriesQueue.removeFirst()
      ];
      final items = await Future.wait(ids.map(_newsApi.item));
      _newStoriesBacking.addAll(items);
      _newStories.value = UngrowableUnmodifiableListView(_newStoriesBacking);
    } finally {
      _loadingNewStories = false;
    }
  }
}
