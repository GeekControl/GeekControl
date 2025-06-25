import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/carousel/hitagi_banner_carousel.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_dialog.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_toast.dart';
import 'package:geekcontrol/view/animes/ui/components/details_component.dart';
import 'package:geekcontrol/view/animes/ui/components/genres_component.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/library/hitagi_cup/utils.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/animes/ui/components/reviews_component.dart';
import 'package:geekcontrol/view/library/model/category_entity.dart';
import 'package:geekcontrol/view/services/anilist/controller/anilist_controller.dart';
import 'package:geekcontrol/view/services/anilist/entities/details_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class DetailsPage extends StatefulWidget {
  static const route = '/details';
  final int id;

  const DetailsPage({super.key, required this.id});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  final _controller = di<AnilistController>();
  late Future<DetailsEntity> _futureDetails;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _futureDetails = _controller.getDetails(widget.id);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DetailsEntity>(
        future: _futureDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final details = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        pinned: false,
                        expandedHeight: 300,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (details.bannerImage.isNotEmpty)
                                HitagiImages(image: details.bannerImage)
                              else
                                HitagiImages(image: details.coverImage),
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black54,
                                      Colors.transparent,
                                      Colors.black87,
                                    ],
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                  child: Container(
                                    color: Colors.black.withValues(alpha: 0),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 16,
                                bottom: 16,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 130,
                                      height: 170,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              92, 124, 77, 255),
                                          width: 2.5,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: HitagiImages(
                                          image: details.coverImage,
                                          width: 130,
                                          height: 170,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          160,
                                      child: Text(
                                        details.titleEnglish.isNotEmpty
                                            ? details.titleEnglish
                                            : details.titleRomaji,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).padding.top + 8,
                                right: 16,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.star_border,
                                    color: Colors.yellowAccent,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    HitagiDialog(
                                        title: 'Favoritar?',
                                        description:
                                            'Deseja adicionar à sua lista de favoritos?',
                                        onPressedButtonAccept: () {
                                          try {
                                            _controller.addToLibrary(
                                                details,
                                                CategoryEntity(
                                                    id: 'default',
                                                    name: 'Geral',
                                                    colorHex: '#FF6C5CE7'));
                                            HitagiToast.show(
                                              context,
                                              message:
                                                  'Adicionado à sua biblioteca.',
                                              type: ToastType.success,
                                            );
                                            context.pop();
                                          } catch (e) {
                                            Logger().e(
                                              'Erro ao adicionar na biblioteca: $e',
                                            );
                                            HitagiToast.show(
                                              context,
                                              message:
                                                  'Erro ao adicionar na biblioteca.',
                                              type: ToastType.error,
                                            );
                                            context.pop();
                                          }
                                        }).show(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: Column(
                    children: [
                      Material(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: TabBar(
                          controller: _tabController,
                          tabs: const [
                            Tab(icon: Icon(Icons.info), text: 'Detalhes'),
                            Tab(
                              icon: Icon(Icons.article_sharp),
                              text: 'Reviews',
                            ),
                          ],
                          indicatorColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DetailsComponent(
                                    label: 'Lançado em',
                                    value: details.startDate?.year.toString() ??
                                        '-',
                                    icon: Icons.calendar_today_outlined,
                                  ),
                                  DetailsComponent(
                                    label: 'Formato',
                                    value:
                                        Utils.formatMediaType(details.format),
                                    icon: Icons.videocam,
                                  ),
                                  DetailsComponent(
                                    label: 'Status',
                                    value: Utils.formatStatus(details.status),
                                    icon: Icons.access_time,
                                  ),
                                  DetailsComponent(
                                    label: 'Fãs',
                                    value: details.popularity.toString(),
                                    icon: Icons.trending_up,
                                  ),
                                  DetailsComponent(
                                    label: 'Nota Média',
                                    value: (details.meanScore / 10)
                                        .toStringAsFixed(1),
                                    icon: Icons.star,
                                  ),
                                  DetailsComponent(
                                    label: 'Fonte',
                                    value: Utils.formatSource(details.source),
                                    icon: Icons.menu_book_outlined,
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GenresComponent(details: details),
                                  ),
                                  const SizedBox(height: 16),
                                  HitagiText(
                                      text: 'Recomendações',
                                      typography: HitagiTypography.title),
                                  const SizedBox(height: 8),
                                  HitagiBanner(
                                    images: details.recommendations
                                        .map((e) => e.bannerImage)
                                        .where(
                                          (image) => image.isNotEmpty,
                                        )
                                        .toList(),
                                    onTap: (index) {
                                      final selected =
                                          details.recommendations[index];
                                      GoRouter.of(context).push(
                                        DetailsPage.route,
                                        extra: selected.id,
                                      );
                                    },
                                  ),
                                  HitagiText(
                                    text: 'Descrição',
                                    typography: HitagiTypography.title,
                                  ),
                                  const SizedBox(height: 8),
                                  HitagiText(
                                    typography: HitagiTypography.button,
                                    text: _controller.translatedDescription ??
                                        details.description,
                                  ),
                                ],
                              ),
                            ),
                            ReviewsComponent(
                              reviews: details.reviews,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
