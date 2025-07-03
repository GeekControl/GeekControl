import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';
import 'package:geekcontrol/view/library/model/category_entity.dart';
import 'package:geekcontrol/view/library/ui/atoms/category_not_found.dart';
import 'package:geekcontrol/view/library/ui/atoms/select_category_item.dart';

class SelectCategory extends StatefulWidget {
  final List<CategoryEntity> categories;
  final void Function(String categoryId) onSelected;
  final String? selectedCategoryId;
  final bool showCreateOption;

  const SelectCategory({
    super.key,
    required this.categories,
    required this.onSelected,
    this.selectedCategoryId,
    this.showCreateOption = true,
  });

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  String searchQuery = '';
  late List<CategoryEntity> filteredCategories;

  @override
  void initState() {
    super.initState();
    filteredCategories =
        widget.categories.where((c) => c.id != 'default').toList();
  }

  void _filterCategories(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredCategories = widget.categories;
      } else {
        filteredCategories = widget.categories
            .where((category) =>
                category.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.category_outlined,
                        color: Color(0xFF6C5CE7),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selecionar Categoria',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          Text(
                            'Escolha uma categoria para organizar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    onChanged: _filterCategories,
                    style: const TextStyle(
                      color: Color(0xFF2D3436),
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Buscar categoria...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: filteredCategories.isEmpty && widget.categories.isNotEmpty
                  ? CategoryNotFound(searchQuery: searchQuery)
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          if (filteredCategories.isNotEmpty) ...[
                            if (widget.showCreateOption)
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: Colors.grey.shade300,
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: HitagiText(
                                        text: 'Suas Categorias',
                                        color: Colors.grey.shade600,
                                        typography:
                                            HitagiTypography.alternative,
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.grey.shade300,
                                        thickness: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ...filteredCategories.map((category) {
                              return SelectCategoryItem(
                                isSelected:
                                    widget.selectedCategoryId == category.id,
                                categoryColor: _parseColor(category.colorHex),
                                category: category,
                                onSelected: widget.onSelected,
                              );
                            }),
                          ] else if (widget.categories.isEmpty) ...[
                            CategoryNotFound(searchQuery: searchQuery),
                          ],
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF6C5CE7);
    }
  }
}
