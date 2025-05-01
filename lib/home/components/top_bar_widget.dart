import 'package:flutter/material.dart';
import 'package:geekcontrol/settings_page/pages/settings_page.dart';
import 'package:go_router/go_router.dart';

class TopBarWidget extends StatelessWidget {
  const TopBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => GoRouter.of(context).push(SettingsPage.route),
        ),
      ],
    );
  }
}
