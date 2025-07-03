import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/utils/assets_enum.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/home/splash/splash_controller.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  static const route = '/splash';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _ct = di<SplashController>();

  @override
  void initState() {
    super.initState();
    _ct.resolveInitialRoute().then((route) {
      if (mounted) GoRouter.of(context).go(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: AnimatedBuilder(
        animation: _ct,
        builder: (_, __) {
          return Stack(
            children: [
              Center(
                child: Image.asset(
                  AssetsEnum.geekcontrolLogoNoBackground.path,
                  width: 180,
                ),
              ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    HitagiText(
                      text: _ct.currentStep,
                      textAlign: TextAlign.center,
                      typography: HitagiTypography.button,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
