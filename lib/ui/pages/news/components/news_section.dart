import 'package:flutter/material.dart';
import 'package:hn_state_example/core/models/news/stories_model.dart';
import 'package:hn_state_example/ui/components/next_page_button.dart';
import 'package:hn_state_example/ui/sliver_persistent_container.dart';
import 'package:hn_state_example/ui/view.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'news_list_tile.dart';

class NewsSection<T extends StoriesModel> extends StatelessWidget {
  final T model;
  final bool infinite;

  const NewsSection({
    Key key,
    @required this.model,
    @required this.infinite,
  }) : super(key: key);

  Widget _list() {
    Widget list = SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (infinite && index > model.newsItems.length - 10) {
            model.nextPage();
          }
          return NewsListTile(
            newsItem:
                index < model.newsItems.length ? model.newsItems[index] : null,
          );
        },
        childCount: model.newsItems.length,
      ),
    );
    list = SliverAnimatedPaintExtent(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: list,
    );
    return list;
  }

  Widget _limitWidth(
    BuildContext context, {
    @required Widget child,
    double padding = 0.0,
  }) {
    return SliverCrossAxisPadded(
      paddingStart: MediaQuery.of(context).padding.left + padding,
      paddingEnd: MediaQuery.of(context).padding.right + padding,
      textDirection: TextDirection.ltr,
      child: SliverCrossAxisConstrained(
        maxCrossAxisExtent: 650,
        child: MediaQuery.removePadding(
          context: context,
          removeLeft: true,
          removeRight: true,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return View<T>(
      cachedModel: model,
      showLoader: false,
      showError: false,
      builder: (context, model, _) {
        return _limitWidth(
          context,
          padding: 24,
          child: MultiSliver(
            pushPinnedChildren: true,
            children: [
              SliverStack(
                insetOnOverlap: true,
                children: [
                  SliverPositioned.fill(
                    top: _CardHeader.topInset,
                    child: _CardBackground(),
                  ),
                  MultiSliver(
                    children: <Widget>[
                      SliverPinnedHeader(
                        child: _CardHeader(
                          title: model.title,
                        ),
                      ),
                      SliverClip(
                        child: MultiSliver(
                          children: <Widget>[
                            _list(),
                            Container(
                              height: 64,
                              alignment: Alignment.center,
                              child: ValueListenableBuilder<bool>(
                                valueListenable: model.loadingNextPage,
                                builder: (context, loading, _) {
                                  if (infinite && !loading)
                                    return const SizedBox.shrink();
                                  return NextPageButton(
                                    loading: loading,
                                    nextPage: model.nextPage,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String title;

  static const double topInset = 24;

  const _CardHeader({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.only(top: topInset),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const <BoxShadow>[
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 8,
            color: Colors.black26,
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
