import 'package:flutter/material.dart';
import 'package:geekcontrol/view/animes/articles/controller/articles_controller.dart';
import 'package:geekcontrol/view/animes/articles/pages/complete_article_page.dart';
import 'package:geekcontrol/view/animes/articles/pages/components/article_card.dart';
import 'package:geekcontrol/view/animes/components/floating_button.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/skeletonizer/cards_skeletonizer.dart';
import 'package:geekcontrol/view/home/atoms/search_page.dart';
import 'package:go_router/go_router.dart';

class ArticlesPage extends StatefulWidget {
  static const route = '/articles';
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final ArticlesController ct = di<ArticlesController>();
  final List<String> readArticles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ct.init();
      setState(() {});
    });

    ct.addListener(() {
      setState(() {});
    });
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
        actions: [
          Padding(padding: const EdgeInsets.only(right: 8.0)),
          IconButton(
            onPressed: () => GoRouter.of(context).push(SearchPage.route),
            icon: const Icon(Icons.search_off_outlined),
          ),
        ],
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Center(
            child: HitagiText(
          text: 'Últimas notícias',
          typography: HitagiTypography.title,
        )),
      ),
      floatingActionButton: HitagiFloattingButton(ct: ct),
      body: ct.isLoading
          ? const CardsSkeletonizer()
          : ListView.builder(
              itemCount: ct.articlesList.length,
              itemBuilder: (context, index) {
                final news = ct.articlesList[index];
                final alreadyRead = ct.isReadSync(news.title);
                return ArticleCard(
                  news: news,
                  isRead: alreadyRead,
                  onLongPress: () => ct.markAsUnread(news.title),
                  onTap: () async {
                    await context.push(
                      CompleteArticlePage.route,
                      extra: {
                        'news': news,
                        'current': ct.currentSite.name,
                      },
                    );
                    await ct.markAsRead(news.title);
                  },
                );
              },
            ),
    );
  }
}
