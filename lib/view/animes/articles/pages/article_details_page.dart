import 'package:flutter/material.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/animes/articles/controller/articles_controller.dart';
import 'package:geekcontrol/view/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/carousel/hitagi_banner_carousel.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';

class ArticleDetailsPage extends StatefulWidget {
  static const route = '/articles/details';
  final ArticlesEntity news;
  final String current;

  const ArticleDetailsPage({
    super.key,
    required this.news,
    required this.current,
  });

  @override
  State<ArticleDetailsPage> createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage> {
  late ArticlesEntity article = widget.news;
  final ArticlesController _ct = di<ArticlesController>();

  Future<void> loadArticles() async {
    final fetched = await _ct.fetchArticleDetails(
      article.sourceUrl!.isEmpty ? article.url : article.sourceUrl!,
      article,
      widget.news.site,
    );
    setState(() {
      article = fetched;
    });
  }

  @override
  void initState() {
    super.initState();
    loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    if (article.content.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[600]!),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: article.imagesPage != null
                  ? HitagiBanner(
                      images: article.imagesPage!, 
                      title: article.title,
                    )
                  : HitagiBanner(
                      images: [article.imageUrl ?? ''], 
                      title: article.title,
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HitagiText(
                      text: article.title,
                      typography: HitagiTypography.title,
                      color: Colors.grey[800],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Colors.purple[600],
                          ),
                          const SizedBox(width: 8),
                          HitagiText(
                            text: article.author,
                            typography: HitagiTypography.small,
                            color: Colors.purple[600],
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.purple[600],
                          ),
                          const SizedBox(width: 8),
                          HitagiText(
                            text: article.date,
                            typography: HitagiTypography.small,
                            color: Colors.purple[600],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple[200]!,
                            Colors.purple[100]!,
                            Colors.purple[200]!,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    HitagiText(
                      text: article.content,
                      typography: HitagiTypography.body,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.purple[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.link,
                              color: Colors.purple[600],
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HitagiText(
                                  text: 'Fonte',
                                  typography: HitagiTypography.small,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(height: 2),
                                HitagiText(
                                  text: article.site,
                                  typography: HitagiTypography.buttonNormal,
                                  color: Colors.grey[700],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}