import 'package:flutter/material.dart';
import 'package:geekcontrol/animes/articles/controller/articles_controller.dart';
import 'package:geekcontrol/animes/articles/entities/articles_entity.dart';
import 'package:geekcontrol/animes/articles/pages/complete_article_page.dart';
import 'package:geekcontrol/animes/components/floating_button.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/default_dialogs.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_search_dialog.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final ArticlesController _ct = ArticlesController();

  @override
  void initState() {
    super.initState();
    _ct.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: HitagiFloattingButton(ct: _ct),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              HitagiSearchDialog(
                controller: _controller,
                hintText: 'Pesquise por uma notícia...',
                onSubmitted: (query) {
                  _ct.changeSearchSite(_ct.currentSite, article: query);
                },
              ),
              Expanded(
                child: FutureBuilder<List<ArticlesEntity>>(
                  future: _ct.articlesSearch,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(FastDescription.error.message),
                      );
                    } else {
                      final List<ArticlesEntity> articles = snapshot.data ?? [];
                      return ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final ArticlesEntity article = articles[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: SizedBox(
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    article.imageUrl!,
                                    width: 80,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Placeholder(
                                        fallbackWidth: 200,
                                        fallbackHeight: 200,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              title: Text(
                                article.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                article.resume,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () => Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: CompleteArticlePage(
                                        news: article,
                                        current: article.site,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
