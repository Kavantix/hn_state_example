import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hn_state_example/core/i18n/strings.dart';
import 'package:hn_state_example/core/models/index.dart';
import 'package:hn_state_example/core/models/news/stories_model.dart';
import 'package:hn_state_example/ui/pages/news/components/news_list_tile.dart';
import 'package:hn_state_example/ui/sliver_persistent_container.dart';
import 'package:hn_state_example/ui/view.dart';
import 'package:sliver_tools/sliver_tools.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key key}) : super(key: key);

  Widget _section<T extends StoriesModel>(
    BuildContext context,
    T model, {
    @required bool infinite,
    bool first = false,
  }) {
    return View<T>(
      cachedModel: model,
      showLoader: false,
      showError: false,
      builder: (context, model, _) {
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
        if (!infinite) {
          list = SliverAnimatedPaintExtent(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: list,
          );
        }
        return MultiSliver(
          pushPinnedChildren: true,
          children: [
            if (first)
              CupertinoSliverRefreshControl(
                onRefresh: () => model.load(),
              ),
            SliverPersistantContainer(
              minExtent: 24,
              maxExtent: 24,
              child: Container(),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              sliver: SliverStack(
                children: [
                  SliverPositioned.fill(
                    child: Container(
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
                    ),
                  ),
                  MultiSliver(
                    // pushPinnedChildren: true,
                    children: <Widget>[
                      SliverPersistantContainer(
                        minExtent: 69,
                        maxExtent: 69,
                        child: Container(
                          child: Container(
                            margin: const EdgeInsets.only(top: 16),
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
                                    model.title,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverClip(
                        child: MultiSliver(
                          children: <Widget>[
                            list,
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: 64,
                                child: Center(
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
                _section(context, model.topStories, infinite: false, first: true),
                _section(context, model.newStories, infinite: true),
                SliverToBoxAdapter(
                  child: SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NextPageButton extends StatelessWidget {
  final bool loading;
  final VoidCallback nextPage;

  const NextPageButton({
    Key key,
    @required this.loading,
    @required this.nextPage,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: loading
          ? const CircularProgressIndicator()
          : RaisedButton(
              child: Text(
                Strings.of(context).pages.news.nextPage,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: nextPage,
              color: Colors.blue,
            ),
    );
  }
}
