import 'package:flutter/material.dart';
import 'package:geekcontrol/animes/articles/pages/articles_page.dart';
import 'package:geekcontrol/animes/ui/pages/latest_releases_page.dart';
import 'package:geekcontrol/services/cache/local_cache.dart';
import 'package:geekcontrol/services/sites/wallpapers/pages/wallpapers_page.dart';
import 'package:geekcontrol/settings/controller/settings_controller.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  static const route = '/settings';
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Funcionalidades',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SettingsTile(
            icon: Icons.image,
            title: 'Wallpapers',
            onTap: () => GoRouter.of(context).push(WallpapersPage.route),
          ),
          SettingsTile(
            icon: Icons.newspaper,
            title: 'Artigos',
            onTap: () => GoRouter.of(context).push(ArticlesPage.route),
          ),
          SettingsTile(
            icon: Icons.notification_add,
            title: 'Últimos lançamentos',
            onTap: () => GoRouter.of(context).push(LatestReleasesPage.route),
          ),
          FutureBuilder<double>(
            future: SettingsController().getCacheSize(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              final size = snapshot.data!.toStringAsFixed(2);
              return SettingsTile(
                icon: Icons.cleaning_services_outlined,
                title: 'Limpar cache - $size MB',
                onTap: () async {
                  await LocalCache().clearCache();
                  (context as Element).markNeedsBuild();
                },
              );
            },
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Outros',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SettingsTile(
            icon: Icons.text_snippet,
            title: 'Página de teste',
            onTap: () => GoRouter.of(context).push('/test'),
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? titleColor;
  final bool? switchValue;
  final ValueChanged<bool>? onChanged;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.titleColor,
  })  : switchValue = null,
        onChanged = null;

  const SettingsTile.switchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.switchValue,
    required this.onChanged,
  })  : subtitle = null,
        onTap = null,
        titleColor = null;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(color: titleColor ?? Colors.black),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: switchValue != null
          ? Switch(
              value: switchValue!,
              onChanged: onChanged,
            )
          : const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: onTap,
    );
  }
}
