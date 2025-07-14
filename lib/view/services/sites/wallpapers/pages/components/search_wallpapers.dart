import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/text/hitagi_text.dart';

class SearchWallpapers {
  void showSearchBottomSheet(BuildContext context, Function(String) onSearch) {
    final TextEditingController searchController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HitagiText(
                text: 'Pesquisar wallpapers',
                typography: HitagiTypography.title,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Digite o termo de pesquisa...',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  final query = value.trim();
                  if (query.isNotEmpty) {
                    onSearch(query);
                  }
                },
              ),
              const SizedBox(height: 24),
              Align(
                child: ElevatedButton(
                  onPressed: () {
                    final query = searchController.text.trim();
                    if (query.isNotEmpty) {
                      onSearch(query);
                    }
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: const HitagiText(
                      text: 'Buscar',
                      typography: HitagiTypography.button,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
