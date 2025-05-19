import 'package:flutter/material.dart';
import 'package:geekcontrol/home/atoms/bottom_bar.dart';
import 'package:geekcontrol/home/pages/home_page.dart';
import 'package:geekcontrol/home/pages/mangas_page.dart';
import 'package:geekcontrol/settings/pages/settings_page.dart';
import 'package:get/get.dart';

class MainScaffold extends StatelessWidget {
  MainScaffold({super.key});

  final RxInt index = 0.obs;

  final List<Widget> screens = [
    HomePage(),
    MangasPage(),
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
