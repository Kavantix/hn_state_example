import 'package:get_it/get_it.dart';
import 'repositories/index.dart';
import 'models/index.dart';
import 'services/index.dart';

GetIt _locate;
T locate<T>() => _locate<T>();

abstract class Locator {
  static void init({GetIt instance}) {
    _locate = instance ?? GetIt.instance;
    _registerSingletons();
    _registerViewModels();
  }

  static void _registerSingletons() {
    _locate.registerLazySingleton<NewsApi>(() => HackernewsApi());
    _locate.registerLazySingleton(() => NewsRepository(locate<NewsApi>()));
  }

  static void _registerViewModels() {
    _locate.registerFactory(() => NewStoriesModel(locate<NewsRepository>()));
    _locate.registerFactory(() => TopStoriesModel(locate<NewsRepository>()));
    _locate.registerFactory(() => NewsModel(locate<TopStoriesModel>(), locate<NewStoriesModel>()));
  }

  static void reassemble() {
    _locate.allowReassignment = true;
    _registerViewModels();
    _locate.allowReassignment = false;
  }

  static void dispose() {
    _locate.reset();
  }
}
