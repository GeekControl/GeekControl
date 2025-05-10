import 'package:flutter/material.dart';
import 'package:geekcontrol/services/cache/local_cache.dart';
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
          SettingsSection(
            title: 'Funcionalidades',
            tiles: [
              SettingsTile(
                icon: Icons.image,
                title: 'Wallpapers',
                onTap: () => GoRouter.of(context).push('/wallpapers'),
              ),
              SettingsTile(
                icon: Icons.movie,
                title: 'Spoilers',
                onTap: () => GoRouter.of(context).push('/spoilers'),
              ),
              SettingsTile(
                icon: Icons.newspaper,
                title: 'Artigos',
                onTap: () => GoRouter.of(context).push('/articles'),
              ),
              SettingsTile(
                icon: Icons.notification_add,
                title: 'Últimos lançamentos',
                onTap: () => GoRouter.of(context).push('/releases'),
              ),
              FutureBuilder<int>(
                future: LocalCache().getCacheSize(),
                builder: (context, snapshot) {
                  final sizeMB = (snapshot.data ?? 0) / (1024 * 1024);
                  final sizeText = sizeMB.toStringAsFixed(2);

                  return SettingsTile(
                    icon: Icons.cleaning_services_outlined,
                    title: 'Limpar cache - $sizeText MB',
                    onTap: () async {
                      await LocalCache().clearCache();
                      (context as Element).markNeedsBuild();
                    },
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Outros',
            tiles: [
              SettingsTile(
                icon: Icons.text_snippet,
                title: 'Página de teste',
                onTap: () => GoRouter.of(context).push('/test'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> tiles;

  const SettingsSection({super.key, required this.title, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        ...tiles,
        const SizedBox(height: 16.0),
      ],
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
