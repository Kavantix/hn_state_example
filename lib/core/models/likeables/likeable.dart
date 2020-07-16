import 'package:flutter/foundation.dart';

class Likeable with ChangeNotifier implements ValueListenable<bool> {
  bool _isLiked;
  @override
  bool get value => _isLiked;

  Likeable(bool isLiked) : _isLiked = isLiked ?? false;

  void like() {
    if (!_isLiked) {
      _isLiked = true;
      notifyListeners();
    }
  }

  void unlike() {
    if (_isLiked) {
      _isLiked = false;
      notifyListeners();
    }
  }
}
