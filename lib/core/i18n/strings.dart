import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Strings {
  static final StringsLocalizationsDelegate delegate = StringsLocalizationsDelegate();
  static Future<Strings> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    Intl.defaultLocale =
        delegate.isSupported(locale) ? localeName : Intl.canonicalizedLocale('nl_NL');

    return Future.value(Strings());
    // return initializeMessages(localeName).then((_) {
    //   Intl.defaultLocale = localeName;
    //   return Strings();
    // });
  }

  static Strings of(BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }

  final pages = const _Pages();
  final errors = const _Errors();
}

class _Pages {
  const _Pages();

  final news = const _PagesNews();
}

class _PagesNews {
  const _PagesNews();

  String get title => Intl.message('Hacker News');
}

class _Errors {
  const _Errors();

  String get failedLoading =>
      Intl.message('Something went wrong while loading.\n press retry to try again.');
  String get tryAgain => Intl.message('Try again');
}

class StringsLocalizationsDelegate extends LocalizationsDelegate<Strings> {
  const StringsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'nl'].contains(locale.languageCode);

  @override
  Future<Strings> load(Locale locale) => Strings.load(locale);

  @override
  bool shouldReload(StringsLocalizationsDelegate old) => true;
}
