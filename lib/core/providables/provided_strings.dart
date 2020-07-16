import 'package:flutter/widgets.dart';

import 'providable.dart';
import '../i18n/strings.dart';

mixin ProvidedStrings on Providable {
  Strings strings;

  @override
  void refreshProvided(BuildContext context) {
    strings = Strings.of(context);
    super.refreshProvided(context);
  }
}
