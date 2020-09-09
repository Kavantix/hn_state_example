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
          if (infinite && index > model.newsItems.length - 5) {
            model.nextPage();
          }
          return NewsListTile(
            newsItem: index < model.newsItems.length ? model.newsItems[index] : null,
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

  Widget _persistentPadding(double height) => SliverPersistantContainer(
        minExtent: height,
        maxExtent: height,
        child: Container(),
      );

  @override
  Widget build(BuildContext context) {
    return View<T>(
      cachedModel: model,
      showLoader: false,
      showError: false,
      builder: (context, model, _) {
        return MultiSliver(
          pushPinnedChildren: true,
          children: [
            _persistentPadding(24),
            SliverPadding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              sliver: SliverStack(
                insetOnOverlap: true,
                children: [
                  SliverPositioned.fill(
                    child: _CardBackground(),
                  ),
                  MultiSliver(
                    children: <Widget>[
                      SliverPersistantContainer(
                        minExtent: 69,
                        maxExtent: 69,
                        child: _CardHeader(
                          title: model.title,
                        ),
                      ),
                      SliverClip(
                        child: MultiSliver(
                          children: <Widget>[
                            _list(),
                            SliverToBoxAdapter(
                              child: Container(
                                height: 64,
                                alignment: Alignment.center,
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: model.loadingNextPage,
                                  builder: (context, loading, _) {
                                    if (infinite && !loading) return const SizedBox.shrink();
                                    return NextPageButton(
                                      loading: loading,
                                      nextPage: model.nextPage,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String title;

  const _CardHeader({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        alignment: Alignment.bottomCenter,
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
