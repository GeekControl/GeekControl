import 'package:flutter/material.dart';

class CategoryNotFound extends StatelessWidget {
  final String searchQuery;
  const CategoryNotFound({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            searchQuery.isEmpty
                ? 'Nenhuma categoria encontrada'
                : 'Nenhuma categoria encontrada para "$searchQuery"',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isEmpty
                ? 'Crie sua primeira categoria para começar!'
                : 'Tente buscar por outro termo ou crie uma nova categoria.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
