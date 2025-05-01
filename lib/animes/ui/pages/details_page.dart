import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geekcontrol/animes/ui/components/genres_component.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/images/hitagi_images.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/library/hitagi_cup/utils.dart';
import 'package:geekcontrol/services/anilist/controller/anilist_controller.dart';
import 'package:geekcontrol/services/anilist/entities/details_entity.dart';

class DetailsPage extends StatefulWidget {
  static const route = '/details';
  final int id;

  const DetailsPage({super.key, required this.id});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  final _controller = AnilistController();
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
                                    color: Colors.black.withOpacity(0),
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
                                          148,
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
                                icon: Icon(Icons.ondemand_video),
                                text: 'Assistir'),
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
                                  _buildInfo('Lançado em',
                                      details.startDate?.year.toString() ?? '-',
                                      icon: Icons.calendar_today_outlined),
                                  _buildInfo('Formato',
                                      Utils.formatMediaType(details.format),
                                      icon: Icons.videocam),
                                  _buildInfo('Status',
                                      Utils.formatStatus(details.status),
                                      icon: Icons.access_time),
                                  _buildInfo(
                                      'Fãs', details.popularity.toString(),
                                      icon: Icons.trending_up),
                                  _buildInfo('Nota Média',
                                      details.meanScore.toString(),
                                      icon: Icons.star),
                                  _buildInfo('Fonte',
                                      Utils.formatSource(details.source),
                                      icon: Icons.menu_book_outlined),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GenresComponent(details: details),
                                  ),
                                  const SizedBox(height: 16),
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
                            _buildWatchTab(),
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

  Widget _buildWatchTab() {
    return const Center(
      child: Text(
        'Funcionalidade de assistir ainda não implementada.',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildInfo(String label, dynamic value, {required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          HitagiText(
            text: '$label: ',
            typography: HitagiTypography.button,
          ),
          Expanded(
            child: HitagiText(
              text: value.toString(),
              typography: HitagiTypography.button,
            ),
          ),
        ],
      ),
    );
  }
}
