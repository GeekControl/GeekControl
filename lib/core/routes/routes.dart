import 'package:geekcontrol/animes/articles/pages/articles_page.dart';
import 'package:geekcontrol/animes/articles/pages/complete_article_page.dart';
import 'package:geekcontrol/animes/season/season_releases.dart';
import 'package:geekcontrol/animes/spoilers/pages/spoilers_page.dart';
import 'package:geekcontrol/animes/ui/pages/details_page.dart';
import 'package:geekcontrol/animes/ui/pages/latest_releases_page.dart';
import 'package:geekcontrol/animes/ui/pages/top_rateds_page.dart';
import 'package:geekcontrol/home/pages/home_page.dart';
import 'package:geekcontrol/services/sites/otakupt/profile.dart';
import 'package:geekcontrol/services/sites/wallpapers/pages/wallpapers_fullscreen_page.dart';
import 'package:geekcontrol/services/sites/wallpapers/pages/wallpapers_page.dart';
import 'package:geekcontrol/settings/pages/settings_page.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
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
        builder: (context, state) => const LatestReleasesPage(),
      ),
      GoRoute(
        path: '/test',
        builder: (context, state) => const SeasonReleasesPage(season: 'Test'),
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
        path: '/top-rateds',
        builder: (context, state) => const TopRatedsPage(),
      ),
      GoRoute(
        path: '/season-releases',
        builder: (context, state) {
          final data = state.extra as String;
          return SeasonReleasesPage(
            season: data,
          );
        },
      ),
    ],
  );
}
