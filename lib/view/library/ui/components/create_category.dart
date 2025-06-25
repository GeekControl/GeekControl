import 'package:flutter/material.dart';
import 'package:geekcontrol/view/library/model/category_entity.dart';
import 'package:geekcontrol/view/library/ui/atoms/create_category_buttons.dart';
import 'package:geekcontrol/view/library/ui/atoms/create_category_colors.dart';
import 'package:geekcontrol/view/library/ui/atoms/create_category_header.dart';
import 'package:geekcontrol/view/library/ui/atoms/create_category_text_field.dart';

class LibraryCreateCategory extends StatefulWidget {
  final CategoryEntity? initial;
  final void Function(CategoryEntity category) onSubmit;

  const LibraryCreateCategory({
    super.key,
    this.initial,
    required this.onSubmit,
  });

  @override
  State<LibraryCreateCategory> createState() => _LibraryCreateCategoryState();
}

class _LibraryCreateCategoryState extends State<LibraryCreateCategory> {
  late final TextEditingController nameCtrl;
  late final TextEditingController colorCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    colorCtrl =
        TextEditingController(text: widget.initial?.colorHex ?? '#6C5CE7');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    colorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 32,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CreateCategoryHeader(isEdit: widget.initial != null),
          const SizedBox(height: 32),
          CreateCategoryTextField(
            label: 'Nome da Categoria',
            hint: 'Ex: Ficção Científica, Romance...',
            controller: nameCtrl,
            icon: Icons.label_outline,
          ),
          const SizedBox(height: 24),
          CreateCategoryTextField(
            label: 'Cor da Categoria',
            hint: '#6C5CE7',
            controller: colorCtrl,
            icon: Icons.circle,
          ),
          const SizedBox(height: 16),
          CreateCategoryColors(colorCtrl: colorCtrl),
          const SizedBox(height: 32),
          CreateCategoryButtons(
            nameCtrl: nameCtrl,
            colorCtrl: colorCtrl,
            initial: widget.initial,
            onSubmit: widget.onSubmit,
          ),
        ],
      ),
    );
  }
}
