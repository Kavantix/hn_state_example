import 'package:flutter/widgets.dart';

import '../providables/providable.dart';

abstract class BaseModel extends ChangeNotifier implements Providable {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  VoidCallback _retryCallback;

  var _isDisposed = false;

  bool startLoading() {
    if (isLoading || hasError) return false;
    _isLoading = true;
    notifyListeners();
    return true;
  }

  void doneLoading() {
    assert(isLoading);
    _isLoading = false;
    notifyListeners();
  }

  void loadingFailed(VoidCallback retryCallback) {
    assert(isLoading);
    _retryCallback = retryCallback;
    _isLoading = false;
    _hasError = false;
    notifyListeners();
  }

  void retryLoading() {
    if (!hasError || _retryCallback == null) return;
    _hasError = false;
    _retryCallback();
    _retryCallback = null;
    notifyListeners();
  }

  @override
  @mustCallSuper
  void notifyListeners() {
    if (_isDisposed) return;
    super.notifyListeners();
  }

  @override
  @mustCallSuper
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void refreshProvided(BuildContext context) {}

  bool get usesAppLifecycle => false;

  void didChangeAppLifecycleState(AppLifecycleState state) {}
}
