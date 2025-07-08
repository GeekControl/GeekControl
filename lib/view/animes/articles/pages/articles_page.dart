import 'package:flutter/material.dart';
import 'package:geekcontrol/core/routes/entities/article_details_route_entity.dart';
import 'package:geekcontrol/view/animes/articles/controller/articles_controller.dart';
import 'package:geekcontrol/view/animes/articles/pages/article_details_page.dart';
import 'package:geekcontrol/view/animes/articles/pages/components/article_card.dart';
import 'package:geekcontrol/view/animes/components/floating_button.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/skeletonizer/cards_skeletonizer.dart';
import 'package:geekcontrol/view/animes/articles/pages/search_article_page.dart';
import 'package:go_router/go_router.dart';

class ArticlesPage extends StatefulWidget {
  static const route = '/articles';
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage>
    with TickerProviderStateMixin {
  final ArticlesController ct = di<ArticlesController>();
  final List<String> readArticles = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ct.init(param: context);
      _animationController.forward();
      setState(() {});
    });

    ct.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    ct.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.colorScheme.onSurface,
          ),
        ),
        title: Center(
          child: const HitagiText(
            text: 'Últimas Notícias',
            typography: HitagiTypography.title,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () =>
                  GoRouter.of(context).push(SearchArticlePage.route),
              icon: Icon(
                Icons.search,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      floatingActionButton: HitagiFloattingButton(ct: ct),
      body: ct.articlesList.isEmpty
          ? const CardsSkeletonizer()
          : Column(
              children: [
                if (ct.articlesList.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 8),
                        HitagiText(
                          text: '${ct.articlesList.length} artigos disponíveis',
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Toque e segure para desmarcar',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await ct.init(param: context);
                        setState(() {});
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: ct.articlesList.length,
                        itemBuilder: (context, index) {
                          final news = ct.articlesList[index];
                          final alreadyRead = ct.isReadSync(news.title);

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: ArticleCard(
                              news: news,
                              isRead: alreadyRead,
                              onLongPress: () {
                                ct.markAsUnread(news.title);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Artigo marcado como não lido',
                                    ),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              },
                              onTap: () async {
                                await context.push(
                                  ArticleDetailsPage.route,
                                  extra: ArticleDetailsRouteEntity(
                                    news: news,
                                    current: index.toString(),
                                  ).toMap(),
                                );
                                await ct.markAsRead(news.title);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
