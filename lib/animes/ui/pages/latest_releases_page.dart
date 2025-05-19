import 'package:flutter/material.dart';
import 'package:geekcontrol/animes/components/fields_component.dart';
import 'package:geekcontrol/animes/ui/pages/details_page.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/utils/skeletonizer/cards_skeletonizer.dart';
import 'package:geekcontrol/home/pages/home_page.dart';
import 'package:geekcontrol/services/anilist/controller/anilist_controller.dart';
import 'package:geekcontrol/services/anilist/entities/releases_anilist_entity.dart';
import 'package:go_router/go_router.dart';

class LatestReleasesPage extends StatefulWidget {
  static const route = '/releases';
  const LatestReleasesPage({super.key});

  @override
  State<LatestReleasesPage> createState() => _LatestReleasesPageState();
}

class _LatestReleasesPageState extends State<LatestReleasesPage> {
  final _ct = AnilistController();
  late Future<List<ReleasesAnilistEntity>> _future;
  final List<int> readers = [];

  @override
  void initState() {
    super.initState();
    _future = _ct.getReleasesAnimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => GoRouter.of(context).pushReplacement(HomePage.route),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Center(
            child: HitagiText(
          text: 'Últimos Lançamentos',
          typography: HitagiTypography.title,
        )),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CardsSkeletonizer();
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final release = snapshot.data![index];
                return GestureDetector(
                  onTap: () => GoRouter.of(context)
                      .push(DetailsPage.route, extra: release.id),
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 4,
                    color: readers.contains(release.id)
                        ? const Color.fromARGB(255, 169, 191, 209)
                        : Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Hero(
                          tag: 'release-${release.id}',
                          child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              child: HitagiImages(
                                image: release.bannerImage,
                                height: 150,
                              )),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(6),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                release.englishTitle,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            FieldsComponent(releases: release),
                          ],
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
