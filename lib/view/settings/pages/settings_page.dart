import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_toast.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/auth/ui/login_page.dart';
import 'package:geekcontrol/view/settings/controller/settings_controller.dart';
import 'package:geekcontrol/view/settings/pages/components/settings_cards.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  static const route = '/settings';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ct = di<SettingsController>();

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: HitagiText(
          text: 'Configurações',
          typography: HitagiTypography.title,
          color: Colors.grey[800],
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildSectionHeader('Funcionalidades'),
          const SizedBox(height: 12),
          SettingsCards(children: [
            SettingsTile(
              icon: Icons.cleaning_services_outlined,
              title: 'Limpar cache',
              subtitle: '${ct.cacheSize.toStringAsFixed(2)} MB utilizados',
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
                  await ct.init();
                  setState(() {});
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
            SettingsTile(
              icon: Globals.isLoggedIn ? Icons.logout : Icons.login_sharp,
              title: Globals.isLoggedIn ? 'Logout' : 'Login',
              subtitle: Globals.isLoggedIn
                  ? 'Sair da conta atual'
                  : 'Entre em sua conta',
              onTap: () async {
                if (Globals.isLoggedIn) {
                  await ct.logout(context);
                  if (context.mounted) {
                    GoRouter.of(context).go(LoginPage.route);
                    setState(() {});
                  }
                } else {
                  GoRouter.of(context).push(LoginPage.route);
                }
              },
            ),
            SettingsTile.switchTile(
              icon: Icons.translate,
              title: 'Traduzir reviews',
              subtitle: 'Traduzir automaticamente as avaliações',
              switchValue: Globals.translateReviews,
              onChanged: (value) {
                ct.setTranslatePrefs(value);
                setState(() {});
              },
            ),
          ]),
          if (kDebugMode) ...[
            const SizedBox(height: 32),
            _buildSectionHeader('Desenvolvimento'),
            const SizedBox(height: 12),
            SettingsCards(children: [
              SettingsTile(
                icon: Icons.text_snippet,
                title: 'Página de teste',
                subtitle: 'Acesse a página de testes do app',
                onTap: () => GoRouter.of(context).push('/test'),
              ),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: HitagiText(
        text: title,
        typography: HitagiTypography.button,
        color: Colors.purple[600],
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
    this.subtitle,
    required this.switchValue,
    required this.onChanged,
  })  : onTap = null,
        titleColor = null;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.purple[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HitagiText(
                      text: title,
                      typography: HitagiTypography.buttonNormal,
                      color: titleColor ?? Colors.grey[800],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      HitagiText(
                        text: subtitle!,
                        typography: HitagiTypography.small,
                        color: Colors.grey[500],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (switchValue != null)
                Switch(
                  value: switchValue!,
                  onChanged: onChanged,
                  activeColor: Colors.purple[600],
                  activeTrackColor: Colors.purple[200],
                )
              else
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.grey[400],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
