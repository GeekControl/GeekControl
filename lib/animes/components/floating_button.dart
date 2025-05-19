import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:geekcontrol/animes/articles/controller/articles_controller.dart';
import 'package:geekcontrol/animes/sites_enum.dart';
import 'package:geekcontrol/core/utils/assets_enum.dart';

class HitagiFloattingButton extends StatelessWidget {
  final ArticlesController _ct;

  const HitagiFloattingButton({super.key, required ArticlesController ct})
      : _ct = ct;

  @override
  Widget build(BuildContext context) {
    return AnimatedFloatingActionButton(
      fabButtons: <Widget>[
        _buildImageFabButton(
          image: AssetsEnum.intoxiLogo,
          heroTag: 'intoxi',
          onPressed: () {
            _ct.changeSite(SitesEnum.intoxi);
          },
          isSelected: _ct.currentIndex == SitesEnum.intoxi.index,
        ),
        _buildImageFabButton(
          image: AssetsEnum.otakuPtLogo,
          heroTag: 'otakuPT',
          onPressed: () {
            _ct.changeSite(SitesEnum.otakuPt);
          },
          isSelected: _ct.currentIndex == SitesEnum.otakuPt.index,
        ),
        _buildImageFabButton(
          image: AssetsEnum.animesNewLogo,
          heroTag: 'animes_new',
          onPressed: () {
            _ct.changeSite(SitesEnum.animesNew);
          },
          isSelected: _ct.currentIndex == SitesEnum.animesNew.index,
        ),
      ],
      animatedIconData: AnimatedIcons.list_view,
      colorStartAnimation: Colors.white,
      colorEndAnimation: Colors.white,
    );
  }

  Widget _buildImageFabButton({
    required AssetsEnum image,
    required VoidCallback onPressed,
    required String heroTag,
    required bool isSelected,
  }) {
    return FloatingActionButton(
      onPressed: onPressed,
      heroTag: heroTag,
      tooltip: 'Pressione',
      backgroundColor: isSelected
          ? const Color.fromARGB(255, 247, 167, 167)
          : const Color.fromARGB(122, 255, 255, 255),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          image.path,
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}
