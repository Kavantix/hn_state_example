import 'package:flutter/material.dart';
import 'package:hn_state_example/core/data/news_item.dart';
import 'package:hn_state_example/core/models/news/likeable_news_model.dart';
import 'package:hn_state_example/ui/view.dart';

class NewsListTile extends StatelessWidget {
  final NewsItem newsItem;

  static int buildNumber = 0;

  const NewsListTile({Key key, @required this.newsItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View<LikeableNewsModel>(
      onModelReady: (model) => model.load(newsItem),
      builder: (context, model, _) {
        return Column(
          children: <Widget>[
            ListTile(
              title: Text(newsItem.title ?? ''),
              subtitle: Text('Build nr: ${buildNumber++}'),
              trailing: ValueListenableBuilder<bool>(
                  valueListenable: model.likeable,
                  builder: (context, liked, _) {
                    return FlatButton(
                      child: Icon(
                        liked ? Icons.favorite : Icons.favorite_border,
                        color: liked ? Colors.red : null,
                      ),
                      onPressed: () {
                        if (liked) {
                          model.likeable.unlike();
                        } else {
                          model.likeable.like();
                        }
                      },
                    );
                  }),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16),
              height: 1,
              color: Colors.grey[300],
            ),
          ],
        );
      },
    );
  }
}
