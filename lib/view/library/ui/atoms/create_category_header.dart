import 'package:flutter/material.dart';

class CreateCategoryHeader extends StatelessWidget {
  final bool isEdit;

  const CreateCategoryHeader({
    super.key,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.category_outlined, color: Color(0xFF6C5CE7)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Editar Categoria' : 'Nova Categoria',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              Text(
                isEdit
                    ? 'Modifique as informações da categoria'
                    : 'Crie uma nova categoria para organizar seus itens',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
