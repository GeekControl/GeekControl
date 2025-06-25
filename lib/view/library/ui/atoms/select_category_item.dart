import 'package:flutter/material.dart';
import 'package:geekcontrol/view/library/model/category_entity.dart';

class SelectCategoryItem extends StatelessWidget {
  final bool isSelected;
  final Color categoryColor;
  final CategoryEntity category;
  final void Function(String categoryId) onSelected;

  const SelectCategoryItem({
    super.key,
    required this.isSelected,
    required this.categoryColor,
    required this.onSelected,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onSelected(category.id);
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? categoryColor.withValues(alpha: 0.1)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? categoryColor : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: categoryColor.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF2D3436)
                          : const Color(0xFF636E72),
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
