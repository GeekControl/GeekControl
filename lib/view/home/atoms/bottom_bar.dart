import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/containter/hitagi_container.dart';

// ignore: must_be_immutable
class CustomNavBar extends StatelessWidget {
  final List<Widget> screens;
  int index;
  final Function(int) onChanged;

  CustomNavBar({
    super.key,
    required this.screens,
    required this.index,
    required this.onChanged,
  });

  final List<IconData> _icons = [
    Icons.slideshow_sharp,
    Icons.menu_book_sharp,
    Icons.library_books_rounded,
    Icons.settings_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return HitagiContainer(
      margin:  EdgeInsets.only(bottom: 12, left: width * 0.2, right: width * 0.2),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainer
                  .withValues(alpha: 0.7),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ]),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: screens.asMap().entries.map((item) {
          final isActive = index == item.key;
          return GestureDetector(
            onTap: () => onChanged(item.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.6)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: isActive
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.6)
                        : Colors.transparent,
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: isActive ? 1.1 : 0.9),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Icon(
                      _icons[item.key],
                      size: 25,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  );
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
