import 'package:flutter/material.dart';
import 'package:hn_state_example/core/data/news_item.dart';
import 'package:hn_state_example/core/models/news/likeable_news_model.dart';
import 'package:hn_state_example/ui/view.dart';

class NewsListTile extends StatelessWidget {
  final NewsItem newsItem;

  const NewsListTile({Key key, @required this.newsItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<LikeableNewsModel>(
      onModelReady: (model) => model.load(newsItem),
      builder: (context, model, _) {
        return ListTile(
          title: Text(newsItem.title),
        );
      },
    );
  }
}
