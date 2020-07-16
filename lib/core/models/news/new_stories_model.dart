import 'package:hn_state_example/core/repositories/index.dart';

import '../base_model.dart';

class NewStoriesModel extends LoadingBaseModel {
  NewStoriesModel(this._repository);

  final NewsRepository _repository;

  Future<void> load() async {}
}
