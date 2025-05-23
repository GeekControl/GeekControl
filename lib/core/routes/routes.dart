import 'package:geekcontrol/animes/articles/pages/articles_page.dart';
import 'package:geekcontrol/animes/articles/pages/complete_article_page.dart';
import 'package:geekcontrol/animes/season/season_releases.dart';
import 'package:geekcontrol/animes/spoilers/pages/spoilers_page.dart';
import 'package:geekcontrol/animes/ui/pages/details_page.dart';
import 'package:geekcontrol/animes/ui/pages/latest_releases_page.dart';
import 'package:geekcontrol/animes/ui/pages/top_rateds_page.dart';
import 'package:geekcontrol/home/atoms/search_page.dart';
import 'package:geekcontrol/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/services/sites/otakupt/profile.dart';
import 'package:geekcontrol/services/sites/wallpapers/pages/wallpapers_fullscreen_page.dart';
import 'package:geekcontrol/services/sites/wallpapers/pages/wallpapers_page.dart';
import 'package:geekcontrol/settings/main_scaffold.dart';
import 'package:geekcontrol/settings/pages/settings_page.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MainScaffold(),
      ),
      GoRoute(
        path: '/articles',
        builder: (context, state) => const ArticlesPage(),
      ),
      GoRoute(
        path: '/articles/details',
        builder: (context, state) {
          final data = state.extra as Map;
          return CompleteArticlePage(
            news: data['news'],
            current: data['current'],
          );
        },
      ),
      GoRoute(
        path: '/releases',
        builder: (context, state) => LatestReleasesPage(
          type: state.extra as AnilistTypes,
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const Profile(),
      ),
      GoRoute(
        path: '/details',
        builder: (context, state) {
          final id = state.extra as int;
          return DetailsPage(id: id);
        },
      ),
      GoRoute(
        path: '/spoilers',
        builder: (context, state) => const SpoilersPage(),
      ),
      GoRoute(
        path: '/wallpapers',
        builder: (context, state) => const WallpapersPage(),
      ),
      GoRoute(
        path: '/wallpaper-fullscreen',
        builder: (context, state) {
          final data = state.extra as Map;
          return WallpaperFullscreen(
              images: data['images'], index: data['index']);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
          path: '/top-rateds',
          builder: (context, state) {
            final type = state.extra as AnilistTypes;
            return TopRatedsPage(type: type);
          }),
      GoRoute(
        path: '/season-releases',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return SeasonReleasesPage(
            season: data['season'],
            type: data['type'],
          );
        },
      ),
    ],
  );
}
