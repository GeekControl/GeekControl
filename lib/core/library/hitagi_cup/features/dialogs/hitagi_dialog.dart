import 'package:flutter/material.dart';
import '../button/hitagi_button.dart';
import '../text/hitagi_text.dart';

// ignore: unused_element
var _description = '';

class HitagiDialog extends StatelessWidget {
  final String? description;
  final String title;
  final void Function()? onPressedButtonClose;
  final void Function()? onPressedButtonAccept;
  final void Function()? onPressedOk;

  const HitagiDialog({
    super.key,
    this.description,
    required this.title,
    this.onPressedButtonClose,
    this.onPressedButtonAccept,
    this.onPressedOk,
  });

  void show(BuildContext context) {
    _description = description ?? '';
    showDialog(context: context, builder: build);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      buttonPadding: EdgeInsets.zero,
      actionsPadding: const EdgeInsets.only(bottom: 6),
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HitagiText(
            text: title,
            typography: HitagiTypography.title,
          ),
          const SizedBox(height: 16),
          HitagiText(
            text: description ?? '',
            typography: HitagiTypography.body,
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Visibility(
            visible: onPressedOk == null,
            replacement: HitagiText(
              text: title,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                onPressedButtonAccept != null
                    ? HitagiButton.text(
                        colorText: Colors.black,
                        label: 'Não',
                        onPressed: onPressedButtonClose ??
                            () => Navigator.pop(context),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(width: 24),
                HitagiButton(
                  label: onPressedButtonAccept != null ? 'Sim' : 'OK',
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  onPressed: onPressedButtonAccept ??
                      () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
