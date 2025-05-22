import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/utils/date_time.dart';
import 'package:geekcontrol/view/services/anilist/entities/releases_anilist_entity.dart';


class FieldsComponent extends StatelessWidget {
  final ReleasesAnilistEntity releases;

  const FieldsComponent({super.key, required this.releases});

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
          'Episódios - ${releases.actuallyEpisode}/${releases.episodes}',
          Icons.movie,
        ),
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
