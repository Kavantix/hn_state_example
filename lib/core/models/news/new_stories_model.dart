import 'package:hn_state_example/core/data/news_item.dart';
import 'package:hn_state_example/core/providables/provided_strings.dart';
import 'package:hn_state_example/core/repositories/index.dart';

import 'stories_model.dart';

class NewStoriesModel extends StoriesModel with ProvidedStrings {
  NewStoriesModel(NewsRepository repository) : super(repository, StoriesTypes.newStories);
  @override
  String get title => strings.pages.news.newStories;
}
