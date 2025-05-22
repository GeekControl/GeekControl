import 'package:flutter/material.dart';
import 'package:geekcontrol/view/home/atoms/bottom_bar.dart';
import 'package:geekcontrol/view/home/components/card_container/animes_card_container.dart';
import 'package:geekcontrol/view/home/components/card_container/mangas_card_container.dart';
import 'package:geekcontrol/view/home/pages/home_default.dart';
import 'package:geekcontrol/view/services/anilist/entities/anilist_types_enum.dart';
import 'package:geekcontrol/view/settings/pages/settings_page.dart';
import 'package:get/get.dart';

class MainScaffold extends StatelessWidget {
  MainScaffold({super.key});

  final RxInt index = 0.obs;

  final List<Widget> screens = [
    HomeDefaultWidget(
      cardContainters: [AnimesCardContainer()],
      type: AnilistTypes.anime,
    ),
    HomeDefaultWidget(
      cardContainters: [MangasCardContainer()],
      type: AnilistTypes.manga,
    ),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Obx(() => screens[index.value]),
      bottomNavigationBar: Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          minimum: const EdgeInsets.only(bottom: 20),
          child: Obx(() => CustomNavBar(
                index: index.value,
                onChanged: (i) => index.value = i,
                screens: screens,
              )),
        ),
      ),
    );
  }
}
