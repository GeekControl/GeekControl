import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_toast.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/settings/controller/settings_controller.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  static const route = '/settings';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ct = SettingsController();

  @override
  void initState() {
    super.initState();
    ct.init();
    ct.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const HitagiText(
            text: 'Configurações',
            typography: HitagiTypography.title,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const HitagiText(
            text: 'Funcionalidades',
            typography: HitagiTypography.button,
          ),
          SettingsTile(
            icon: Icons.cleaning_services_outlined,
            title: 'Limpar cache - ${ct.cacheSize.toStringAsFixed(2)} MB',
            onTap: () async {
              try {
                await ct.clearCache();
                if (context.mounted) {
                  HitagiToast.show(
                    context,
                    message: 'Cache limpo com sucesso!',
                    type: ToastType.success,
                  );
                }
                ct.cacheSize = await ct.getCacheSize();
              } catch (e) {
                if (context.mounted) {
                  HitagiToast.show(
                    context,
                    message: 'Erro ao limpar o cache: $e',
                    type: ToastType.error,
                  );
                }
              }
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
