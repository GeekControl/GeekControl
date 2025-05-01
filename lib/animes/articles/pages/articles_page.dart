import 'package:flutter/material.dart';
import 'package:geekcontrol/animes/articles/controller/articles_controller.dart';
import 'package:geekcontrol/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/animes/articles/pages/complete_article_page.dart';
import 'package:geekcontrol/animes/articles/pages/components/article_card.dart';
import 'package:geekcontrol/animes/components/floating_button.dart';
import 'package:geekcontrol/animes/sites_enum.dart';
import 'package:geekcontrol/core/utils/skeletonizer/cards_skeletonizer.dart';
import 'package:go_router/go_router.dart';

class ArticlesPage extends StatefulWidget {
  static const route = '/articles';
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final ArticlesController ct = ArticlesController();
  final List<String> readArticles = [];

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ct.changedSite(SitesEnum.defaultSite));
    ct.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    ct.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Center(child: Text('Últimas Notícias')),
      ),
      floatingActionButton: HitagiFloattingButton(ct: ct),
      body: FutureBuilder<List<ArticlesEntity>>(
        future: ct.articles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const CardsSkeletonizer();
          } else {
            final newsList = snapshot.data!;
            return AnimatedList(
              initialItemCount: newsList.length,
              itemBuilder: (context, index, animation) {
                final news = newsList[index];

                return FutureBuilder<bool>(
                  future: ct.isRead(news.title, readArticles),
                  builder: (context, isReadSnapshot) {
                    if (isReadSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container();
                    }
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: ArticleCard(
                        news: news,
                        isRead: isReadSnapshot.data ?? false,
                        onLongPress: () async {
                          await ct.markAsUnread(news.title, readArticles);
                        },
                        onTap: () async {
                          await Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: CompleteArticlePage(
                                      news: news, current: news.site),
                                );
                              },
                            ),
                          );
                          await ct.markAsRead(news.title, readArticles);
                        },
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
