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
          body: const Center(
        child: CircularProgressIndicator(),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: HitagiText(
          text: 'Detalhes da Notícia',
          typography: HitagiTypography.title,
        )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            article.imagesPage != null
                ? HitagiBanner(
                    images: article.imagesPage!, title: article.title)
                : HitagiBanner(
                    images: [article.imageUrl!], title: article.title),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HitagiText(
                    text: 'Por ${article.author} | ${article.date}',
                  ),
                  const SizedBox(height: 16),
                  HitagiText(text: article.content),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
