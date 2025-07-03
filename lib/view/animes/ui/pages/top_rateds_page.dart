import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/containter/hitagi_container.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/view/animes/ui/components/align_fields_component.dart';
import 'package:geekcontrol/view/animes/ui/components/meanscore_field_component.dart';
import 'package:geekcontrol/view/animes/ui/components/status_field_component.dart';
import 'package:geekcontrol/view/animes/ui/pages/details_page.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/services/anilist/controller/anilist_controller.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/view/services/anilist/entities/rates_entity.dart';
import 'package:go_router/go_router.dart';

class TopRatedsPage extends StatefulWidget {
  final AnilistTypes type;
  static const route = '/top-rateds';
  const TopRatedsPage({super.key, required this.type});

  @override
  State<TopRatedsPage> createState() => _TopRatedsPageState();
}

class _TopRatedsPageState extends State<TopRatedsPage> {
  final _ct = di<AnilistController>();
  final List<AnilistRatesEntity> _rates = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await _ct.init(widget.type);
    final result = await _ct.getRates(type: widget.type);
    if (!mounted) return;
    setState(() {
      _rates
        ..clear()
        ..addAll(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Center(
          child: HitagiText(
            text: 'Mais Avaliados',
            typography: HitagiTypography.title,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _rates.length,
        itemBuilder: (context, index) {
          final rate = _rates[index];
          final release =
              index < _ct.releasesList.length ? _ct.releasesList[index] : null;

          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: () => context.push(DetailsPage.route, extra: rate.id),
              child: HitagiContainer(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color.fromARGB(65, 0, 0, 0), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 25,
                        offset: const Offset(0, 8)),
                    BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 10,
                        offset: const Offset(0, 2)),
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
                            tag: 'toprated-${rate.id}',
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
                                  image: rate.coverImage,
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
                          StatusFieldComponent(status: rate.status),
                          if (rate.meanScore > 0)
                            MeanscoreFieldComponent(meanScore: rate.meanScore),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HitagiText(
                              text: rate.title,
                              typography: HitagiTypography.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 16),
                            if (release != null)
                              AlignFieldsComponent(
                                release: release,
                                type: widget.type,
                              ),
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
