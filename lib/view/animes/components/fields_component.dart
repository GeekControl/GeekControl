import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/utils/date_time.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/releases_anilist_entity.dart';

class FieldsComponent extends StatelessWidget {
  final AnilistTypes type;
  final ReleasesAnilistEntity releases;

  const FieldsComponent(
      {super.key, required this.releases, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 6),
        HitagiText.icon(
          releases.status,
          Icons.access_time,
        ),
        const SizedBox(height: 4),
        HitagiText.icon(
          'Autor - ${releases.author}',
          Icons.person,
        ),
        const SizedBox(height: 4),
        HitagiText.icon(
          type == AnilistTypes.anime
              ? 'Episódios - ${releases.actuallyEpisode}/${releases.episodes}'
              : 'Capítulos - ${releases.chapters}',
          Icons.movie,
        ),
        releases.volumes! > 0
            ? HitagiText.icon(
                'Volumes - ${releases.volumes}',
                Icons.video_library,
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 4),
        HitagiText.icon(
          'Próximo episódio - ${DateTimeUtil().formatUnixDateTime(releases.airingAt, 'dd-MM')}',
          Icons.calendar_month,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
