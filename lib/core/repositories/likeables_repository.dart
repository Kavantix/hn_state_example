import 'package:hn_state_example/core/models/likeables/likeable.dart';

class LikeablesRepository {
  final _likeables = <int, Likeable>{};

  Likeable likeableFor(int id) {
    return _likeables[id] ??= Likeable(false);
  }
}
