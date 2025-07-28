import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_toast.dart';
import 'package:geekcontrol/core/library/page_builder/hitagi_page.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/library/model/category_entity.dart';
import 'package:geekcontrol/view/services/cache/keys_enum.dart';
import 'package:geekcontrol/view/services/firebase/firebase.dart';
import 'package:geekcontrol/view/library/model/library_entity.dart';
import 'package:logger/logger.dart';

class LibraryController extends HitagiController {
  String? _selectedCategoryId;
  String? get selectedCategoryId => _selectedCategoryId;

  List<CategoryEntity> categories = [];
  List<LibraryEntity> content = [];

  int imagesPerLine = 3;

  @override
  Future<void> init({dynamic param}) async {
    await getCategories();
    await getLibrary();
    await getPreferences();
    notifyListeners();
  }

  String get _collection => 'library';
  FirebaseService get _service => di<FirebaseService>();
  String get libraryDefaultId => 'default';

  Future<void> addInLibrary(LibraryEntity data) async {
    handleTry(() async {
      await _service.add(
        collection: _collection,
        doc: Globals.uid!,
        subcollection: 'items',
        subdoc: data.id,
        data: data.toJson(),
      );
    });
  }

  void setSelectedCategory(String? id) {
    _selectedCategoryId = id;
    notifyListeners();
  }

  List<LibraryEntity> get filteredContent {
    if (_selectedCategoryId == null || _selectedCategoryId == 'default') {
      return content;
    }
    return content.where((e) => e.categoryId == _selectedCategoryId).toList();
  }

  Future<void> getCategories() async {
    handleTry(() async {
      final defaultCategory = CategoryEntity(
        id: libraryDefaultId,
        name: 'Todos',
        colorHex: '#2D3436',
        editable: false,
      );
      final s = await _service.getAll(
        collection: _collection,
        doc: Globals.uid!,
        subcollection: 'categories',
      );
      if (s.isEmpty) {
        categories.add(defaultCategory);
        await createCategory(defaultCategory);
        notifyListeners();
        return;
      }
      categories = s.map((e) => CategoryEntity.fromJson(e)).toList();
      notifyListeners();
      Logger().i('Categories loaded with ${categories.length} items.');
    });
  }

  Future<void> createCategory(CategoryEntity category) async {
    handleTry(() async {
      await _service.add(
        collection: _collection,
        doc: Globals.uid!,
        subcollection: 'categories',
        subdoc: category.id,
        data: category.toJson(),
      );

      final index = categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        categories[index] = category;
      } else {
        categories.add(category);
      }
      notifyListeners();
    });
  }

  Future<void> getLibrary() async {
    handleTry(() async {
      final data = await _service.getAll(
        collection: _collection,
        doc: Globals.uid!,
        subcollection: 'items',
      );

      content = data.map((e) => LibraryEntity.fromJson(e)).toList();
      notifyListeners();
      Logger().i('Library loaded with ${content.length} items.');
    });
  }

  List<LibraryEntity> filterByCategory(
    String? categoryId,
  ) {
    if (categoryId == null || categoryId == libraryDefaultId) return content;
    return content.where((e) => e.categoryId == categoryId).toList();
  }

  Future<void> deleteCategory(String categoryId, BuildContext context) async {
    handleTry(() async {
      await _service.delete(
        collection: _collection,
        doc: Globals.uid!,
        subcollection: 'categories',
        subdoc: categoryId,
      );
      categories.removeWhere((e) => e.id == categoryId);
      notifyListeners();
    }, onError: (e, s) {
      Logger().e('Erro ao excluir categoria: $e');
      if (context.mounted) {
        HitagiToast.show(
          context,
          message: 'Erro ao excluir categoria.',
          type: ToastType.error,
        );
      }
    });
  }

  Future<void> savePreferences(
      BuildContext context, String key, dynamic value) async {
    handleTry(() async {
      await cache.setUserPreference(key, value);
    });
  }

  Future<void> getPreferences() async {
    handleTry(() async {
      final itemsPerLine = await cache.getUserPreference<int>(
        CacheKeys.itemsPerLine.value,
      );
      if (itemsPerLine != null) {
        imagesPerLine = itemsPerLine;
        notifyListeners();
      }
    });
  }

  Future<void> delete(String id, BuildContext context) async {
    handleTry(() async {
      await _service.delete(
        collection: _collection,
        doc: Globals.uid!,
        subcollection: 'items',
        subdoc: id,
      );
      content.removeWhere((e) => e.id == id);
      if (context.mounted) {
        HitagiToast.show(
          context,
          message: 'Item excluído com sucesso.',
          type: ToastType.success,
        );
      }
      notifyListeners();
    }, onError: (e, s) {
      Logger().e('Erro ao excluir item: $e');
      if (context.mounted) {
        HitagiToast.show(
          context,
          message: 'Erro ao excluir item.',
          type: ToastType.error,
        );
      }
    });
  }
}
