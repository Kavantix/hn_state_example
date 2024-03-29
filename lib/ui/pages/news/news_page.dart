import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hn_state_example/core/i18n/strings.dart';
import 'package:hn_state_example/core/models/index.dart';
import 'package:hn_state_example/ui/view.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'components/news_section.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Strings.of(context).pages.news.title,
        ),
      ),
      body: View<NewsModel>(
        onModelReady: (model) => model.load(),
        builder: (context, model, _) {
          return Scrollbar(
            child: CustomScrollView(
              slivers: [
                MultiSliver(
                  children: [
                    CupertinoSliverRefreshControl(
                      onRefresh: () => model.load(),
                    ),
                    NewsSection(
                      model: model.topStories,
                      infinite: false,
                    ),
                    NewsSection(
                      model: model.newStories,
                      infinite: true,
                    ),
                    SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
