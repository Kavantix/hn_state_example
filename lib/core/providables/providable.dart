import 'package:flutter/widgets.dart';

abstract class Providable {
  @mustCallSuper
  void refreshProvided(BuildContext context) {}
}
