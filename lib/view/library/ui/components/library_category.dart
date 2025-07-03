import 'package:flutter/material.dart';
import 'package:geekcontrol/view/library/model/category_entity.dart';
import 'package:geekcontrol/view/library/ui/components/create_category.dart';

class LibraryCategory extends StatefulWidget {
  final List<CategoryEntity> categories;
  final ValueChanged<CategoryEntity?> onSelected;
  final Future<void> Function(CategoryEntity) onCreate;

  const LibraryCategory({
    super.key,
    required this.categories,
    required this.onSelected,
    required this.onCreate,
  });

  @override
  State<LibraryCategory> createState() => _LibraryCategoryState();
}

class _LibraryCategoryState extends State<LibraryCategory> {
  CategoryEntity? selected;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelected(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.categories.toList()
      ..sort((a, b) => (a.id == 'default'
          ? -1
          : b.id == 'default'
              ? 1
              : 0));

    Color hexToColor(String hex) {
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse('0x$hex'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          ...categories.map((cat) {
            final isSelected = (selected == null && cat.id == 'default') ||
                (selected?.id == cat.id);

            return GestureDetector(
              onTap: () {
                setState(() {
                  selected = cat;
                  widget.onSelected(cat.id == 'default' ? null : cat);
                });
              },
              onLongPress: cat.id != 'default'
                  ? () => _openCategoryEditor(context, category: cat)
                  : null,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: isSelected
                        ? [
                            cat.colorHex.isNotEmpty
                                ? hexToColor(cat.colorHex)
                                : hexToColor(cat.colorHex),
                            Color(0xFFA29BFE)
                          ]
                        : [Color(0xFF2D3436), Color(0xFF2D3436)],
                  ),
                ),
                child: Text(
                  cat.name,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: isSelected ? 1 : 0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
          GestureDetector(
            onTap: () => _openCategoryEditor(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF00CEC9), Color(0xFF00B894)],
                ),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _openCategoryEditor(BuildContext context,
      {CategoryEntity? category}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return LibraryCreateCategory(
          initial: category,
          onSubmit: (newCategory) async {
            await widget.onCreate(newCategory);
            setState(() {
              selected = newCategory;
            });
            widget.onSelected(newCategory);
          },
        );
      },
    );
  }
}
