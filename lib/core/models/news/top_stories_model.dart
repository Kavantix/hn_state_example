import 'package:hn_state_example/core/providables/provided_strings.dart';
import 'package:hn_state_example/core/repositories/index.dart';

import 'stories_model.dart';

class TopStoriesModel extends StoriesModel with ProvidedStrings {
  TopStoriesModel(NewsRepository repository) : super(repository, StoriesTypes.topStories);

  @override
  String get title => strings.pages.news.topStories;
}
