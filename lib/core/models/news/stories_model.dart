import 'package:flutter/foundation.dart';
import 'package:hn_state_example/core/data/news_item.dart';
import 'package:hn_state_example/core/repositories/index.dart';

import '../base_model.dart';

abstract class StoriesModel extends BaseModel {
  StoriesModel(this._repository, this._type);

  final StoriesTypes _type;
  final NewsRepository _repository;

  List<NewsItem> get newsItems => _repository.stories(_type).value ?? [];

  bool get hasNextPage => _repository.hasNextStoriesPage;

  final _loadingNextPage = ValueNotifier(false);
  ValueListenable<bool> get loadingNextPage => _loadingNextPage;

  void nextPage() async {
    if (loadingNextPage.value) return;
    _loadingNextPage.value = true;
    await _repository.nextStoriesPage();
    _loadingNextPage.value = false;
  }

  Future<void> load() async {
    if (!startLoading()) return;
    await _repository.reset();
    _repository.stories(_type).removeListener(notifyListeners);
    _repository.stories(_type).addListener(notifyListeners);
    await _repository.loadingStories;
    doneLoading();
  }

  @override
  void dispose() {
    _repository.stories(_type).removeListener(notifyListeners);
    super.dispose();
  }

  String get title;
}
