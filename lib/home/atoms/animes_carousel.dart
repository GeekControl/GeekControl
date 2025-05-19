import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/library/hitagi_cup/utils.dart';
import 'package:geekcontrol/core/utils/convert_state.dart';
import 'package:geekcontrol/core/utils/loader_indicator.dart';
import 'package:geekcontrol/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/services/anilist/entities/releases_anilist_entity.dart';
import 'package:geekcontrol/services/anilist/repository/anilist_repository.dart';

class AnimesCarouselWidget extends StatelessWidget {
  final AnilistTypes type;
  const AnimesCarouselWidget({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: AnilistRepository().getReleasesAnimes(type: type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Loader.pacman());
        } else {
          final releases = snapshot.data![0] as ReleasesAnilistEntity;

          return Scaffold(
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.network(
                    releases.bannerImage,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2 + 35,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.5,
                  top: 60,
                  left: 60 / 30,
                  right: 60 / 30,
                  child: Row(
                    children: [
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              releases.coverImage,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HitagiText(
                            text: releases.englishTitle,
                            typography: HitagiTypography.giga,
                          ),
                          const HitagiText(
                            text:
                                '${'anilist.review.first.averageScore'}% Gostaram',
                            icon: Icons.star,
                            typography: HitagiTypography.title,
                            iconColor: Color.fromARGB(255, 223, 201, 4),
                          ),
                          HitagiText(
                            text: MangaStates.toPortuguese(releases.artist),
                            typography: HitagiTypography.title,
                            icon: Icons.remove_red_eye_sharp,
                          ),
                          const HitagiText(
                            text:
                                '${'anilist.genres.first'} ⚬ ${'anilist.genres[1]'}',
                            size: 16,
                            icon: Icons.book,
                            isBold: true,
                          ),
                          HitagiText(
                            text: Utils.timeFromMSeconds(releases.seasonYear),
                            size: 16,
                            icon: Icons.book,
                            isBold: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
