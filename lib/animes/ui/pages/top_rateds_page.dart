import 'package:flutter/material.dart';
import 'package:geekcontrol/animes/ui/pages/details_page.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/library/hitagi_cup/utils.dart';
import 'package:geekcontrol/core/utils/skeletonizer/cards_skeletonizer.dart';
import 'package:geekcontrol/home/pages/home_page.dart';
import 'package:geekcontrol/services/anilist/controller/anilist_controller.dart';
import 'package:geekcontrol/services/anilist/entities/rates_entity.dart';
import 'package:go_router/go_router.dart';

class TopRatedsPage extends StatefulWidget {
  static const route = '/top-rateds';
  const TopRatedsPage({super.key});

  @override
  State<TopRatedsPage> createState() => _TopRatedsPageState();
}

class _TopRatedsPageState extends State<TopRatedsPage> {
  final _ct = AnilistController();
  late Future<List<MangasRates>> _future;

  @override
  void initState() {
    super.initState();
    _future = _ct.getRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => GoRouter.of(context).pushReplacement(HomePage.route),
          icon: const Icon(Icons.arrow_back),
        ),
        title: HitagiText(
          text: 'Mais Avaliados',
          typography: HitagiTypography.title,
        ),
      ),
      body: FutureBuilder<List<MangasRates>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CardsSkeletonizer();
          } else {
            final rates = snapshot.data!;
            return ListView.builder(
              itemCount: rates.length,
              itemBuilder: (context, index) {
                final manga = rates[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: InkWell(
                    onTap: () => GoRouter.of(context).push(DetailsPage.route, extra: manga.id),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8)),
                          child: Image.network(
                            manga.coverImage,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  manga.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              HitagiText.icon(
                                'Rank: ${index + 1}',
                                Icons.military_tech_outlined,
                                typography: HitagiTypography.button,
                              ),
                              HitagiText.icon(
                                'Título alternativo: ${Utils.maxCharacters(30, text: manga.alternativeTitle)}',
                                Icons.title_outlined,
                                typography: HitagiTypography.button,
                              ),
                              HitagiText.icon(
                                'Nota: ${manga.meanScore}',
                                Icons.star,
                                typography: HitagiTypography.button,
                              ),
                              HitagiText.icon(
                                'Status: ${Utils.formatStatus(manga.status)}',
                                Icons.access_time,
                                typography: HitagiTypography.button,
                              ),
                              HitagiText.icon(
                                'Episódios: ${manga.episodes}',
                                Icons.movie,
                                typography: HitagiTypography.button,
                              ),
                              HitagiText.icon(
                                'Adaptado de: ${Utils.formatSource(manga.source)}',
                                Icons.book_outlined,
                                typography: HitagiTypography.button,
                              ),
                              HitagiText.icon(
                                'Formato: ${Utils.formatMediaType(manga.format)}',
                                Icons.videocam,
                                typography: HitagiTypography.button,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
