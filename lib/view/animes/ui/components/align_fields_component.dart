import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/containter/hitagi_container.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_toast.dart';
import 'package:geekcontrol/core/library/hitagi_cup/utils.dart';
import 'package:geekcontrol/view/animes/ui/components/field_component.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/releases_anilist_entity.dart';

class AlignFieldsComponent extends StatelessWidget {
  final ReleasesAnilistEntity release;
  final AnilistTypes type;
  const AlignFieldsComponent({
    super.key,
    required this.release,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        GestureDetector(
          onTap: () => HitagiToast.show(context,
              message: release.author, type: ToastType.success),
          child: HitagiContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667eea).withValues(
                    alpha: 0.25,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FieldComponent(
              field: release.author,
            ),
          ),
        ),
        if (type == AnilistTypes.anime)
          HitagiContainer(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9C27B0).withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FieldComponent(
              icon: type == AnilistTypes.anime
                  ? Icons.tv_rounded
                  : Icons.menu_book_rounded,
              field: '${release.actuallyEpisode}/${release.episodes}',
            ),
          ),
        HitagiContainer(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 94, 12, 5),
                Color.fromARGB(255, 101, 16, 20)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FieldComponent(
            field: Utils.formatSource(release.source),
            icon: Icons.type_specimen_outlined,
          ),
        ),
      ],
    );
  }
}
