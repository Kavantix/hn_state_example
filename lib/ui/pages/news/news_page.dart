import 'package:flutter/material.dart';
import 'package:hn_state_example/core/i18n/strings.dart';
import 'package:hn_state_example/core/models/index.dart';
import 'package:hn_state_example/ui/view.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Strings.of(context).pages.news.title,
        ),
      ),
      body: View<NewsModel>(
        builder: (context, model, _) {
          return CustomScrollView(
            slivers: [
              View<TopStoriesModel>(
                cachedModel: model.topStories,
                showLoader: false,
                showError: false,
                builder: (context, model, _) {
                  return SliverToBoxAdapter(child: Text(model.runtimeType.toString()));
                },
              ),
              View<NewStoriesModel>(
                cachedModel: model.newStories,
                showLoader: false,
                showError: false,
                builder: (context, model, _) {
                  return SliverToBoxAdapter(child: Text(model.runtimeType.toString()));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
