import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/containter/hitagi_container.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/view/animes/ui/components/align_fields_component.dart';
import 'package:geekcontrol/view/animes/ui/components/meanscore_field_component.dart';
import 'package:geekcontrol/view/animes/ui/components/next_episode_field_component.dart';
import 'package:geekcontrol/view/animes/ui/components/status_field_component.dart';
import 'package:geekcontrol/view/animes/ui/pages/details_page.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/skeletonizer/cards_skeletonizer.dart';
import 'package:geekcontrol/view/services/anilist/controller/anilist_controller.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/releases_anilist_entity.dart';
import 'package:go_router/go_router.dart';

class LatestReleasesPage extends StatefulWidget {
  static const route = '/releases';
  final AnilistTypes type;
  const LatestReleasesPage({super.key, required this.type});

  @override
  State<LatestReleasesPage> createState() => _LatestReleasesPageState();
}

class _LatestReleasesPageState extends State<LatestReleasesPage> {
  final _ct = di<AnilistController>();
  final List<ReleasesAnilistEntity> _releases = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final fetched = await _ct.getReleasesAnimes(type: widget.type);
    if (!mounted) return;
    setState(() {
      _releases
        ..clear()
        ..addAll(fetched);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const HitagiText(
          text: 'Últimos Lançamentos',
          typography: HitagiTypography.title,
        ),
      ),
      body: _loading
          ? const CardsSkeletonizer()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _releases.length,
              itemBuilder: (context, index) {
                final release = _releases[index];

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: GestureDetector(
                    onTap: () => context.push(
                      DetailsPage.route,
                      extra: release.id,
                    ),
                    child: HitagiContainer(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color.fromARGB(65, 0, 0, 0),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 25,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Hero(
                                  tag: 'release-${release.id}',
                                  child: HitagiContainer(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      child: HitagiImages(
                                        image: release.bannerImage,
                                        height: 200,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: HitagiContainer(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withAlpha(100),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                StatusFieldComponent(status: release.status),
                                if (release.meanScore > 0)
                                  MeanscoreFieldComponent(
                                      meanScore: release.meanScore),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HitagiText(
                                    text: release.englishTitle,
                                    typography: HitagiTypography.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 16),
                                  AlignFieldsComponent(
                                    type: widget.type,
                                    author: release.author,
                                    episodes: release.episodes,
                                    actuallyEpisode: release.actuallyEpisode,
                                    source: release.source,
                                    status: release.status,
                                  ),
                                  const SizedBox(height: 16),
                                  if (release.airingAt > 0)
                                    NextEpisodeFieldComponent(
                                        airingAt: release.airingAt),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
