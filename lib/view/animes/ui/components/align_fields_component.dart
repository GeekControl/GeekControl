import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/containter/hitagi_container.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_toast.dart';
import 'package:geekcontrol/core/library/hitagi_cup/utils.dart';
import 'package:geekcontrol/view/animes/ui/components/field_component.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';

class AlignFieldsComponent extends StatelessWidget {
  final String author;
  final int? episodes;
  final int? actuallyEpisode;
  final String source;
  final AnilistTypes type;
  final String status;

  const AlignFieldsComponent({
    super.key,
    required this.author,
    required this.episodes,
    required this.actuallyEpisode,
    required this.source,
    required this.type,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        GestureDetector(
          onTap: () => HitagiToast.show(
            context,
            message: author,
            type: ToastType.success,
          ),
          child: HitagiContainer(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667eea).withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FieldComponent(field: author),
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
              icon: Icons.tv_rounded,
              field: (status == 'FINISHED' || status == 'Finalizado'
                  ? '${episodes ?? 0}/${episodes ?? 0}'
                  : '${actuallyEpisode ?? 0}/${episodes ?? 0}'),
            ),
          ),
        HitagiContainer(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 94, 12, 5),
                Color.fromARGB(255, 101, 16, 20),
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
            field: Utils.formatSource(source),
            icon: Icons.type_specimen_outlined,
          ),
        ),
      ],
    );
  }
}
