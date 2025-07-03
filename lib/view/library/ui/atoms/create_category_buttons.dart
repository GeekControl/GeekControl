import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/library/controllers/library_controller.dart';
import 'package:geekcontrol/view/library/model/category_entity.dart';
import 'package:uuid/uuid.dart';

class CreateCategoryButtons extends StatefulWidget {
  final TextEditingController nameCtrl;
  final TextEditingController colorCtrl;
  final CategoryEntity? initial;
  final void Function(CategoryEntity category) onSubmit;

  const CreateCategoryButtons({
    super.key,
    required this.nameCtrl,
    required this.colorCtrl,
    required this.initial,
    required this.onSubmit,
  });

  @override
  State<CreateCategoryButtons> createState() => _CreateCategoryButtonsState();
}

class _CreateCategoryButtonsState extends State<CreateCategoryButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const HitagiText(
                  text: 'Cancelar',
                  color: Color(0xFF636E72),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.nameCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const HitagiText(
                          text: 'Por favor, insira um nome para a categoria',
                        ),
                        backgroundColor: Colors.red.shade400,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                    return;
                  }
                  final category = CategoryEntity(
                    id: widget.initial?.id ?? const Uuid().v4(),
                    name: widget.nameCtrl.text.trim(),
                    colorHex: widget.colorCtrl.text.trim(),
                    editable: true,
                  );
                  widget.onSubmit(category);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: const Color(0xFF6C5CE7).withValues(alpha: 0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.initial == null ? Icons.add : Icons.save,
                        size: 20),
                    const SizedBox(width: 8),
                    HitagiText(
                      text: widget.initial == null
                          ? 'Criar Categoria'
                          : 'Salvar Alterações',
                      color: Colors.white,
                      typography: HitagiTypography.button,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (widget.initial != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Center(
              child: TextButton.icon(
                onPressed: () async {
                  await di<LibraryController>().deleteCategory(
                    widget.initial!.id,
                    context,
                  );
                  if (context.mounted) {
                    Navigator.pop(context, true);
                  }
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const HitagiText(
                  text: 'Excluir Categoria',
                  color: Colors.red,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
