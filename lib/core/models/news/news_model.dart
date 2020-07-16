import 'package:hn_state_example/core/models/base_model.dart';
import 'package:hn_state_example/core/models/news/new_stories_model.dart';
import 'package:hn_state_example/core/models/news/top_stories_model.dart';

class NewsModel extends BaseModel {
  final TopStoriesModel topStories;
  final NewStoriesModel newStories;

  NewsModel(this.topStories, this.newStories);

  Future<void> load() async {
    if (!startLoading()) return;
    try {
      await Future.wait<dynamic>([topStories.load(), newStories.load()]);
      if (topStories.hasError || newStories.hasError) {
        loadingFailed(load);
      } else {
        doneLoading();
      }
    } on dynamic {
      loadingFailed(load);
    }
  }
}
