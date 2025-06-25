import 'package:flutter/material.dart';
import 'package:geekcontrol/core/library/hitagi_cup/features/dialogs/hitagi_toast.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/view/library/model/category_entity.dart';
import 'package:geekcontrol/view/services/firebase/firebase.dart';
import 'package:geekcontrol/view/library/model/library_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class LibraryController extends ChangeNotifier {
  List<CategoryEntity> categories = [];
  List<LibraryEntity> content = [];

  void init() async {
    await getCategories();
    await getLibrary();
    notifyListeners();
  }

  String get _collection => 'library';
  FirebaseService get _service => di<FirebaseService>();

  Future<void> addInLibrary(LibraryEntity data) async {
    try {
      await _service.add(
        collection: _collection,
        doc: Globals.uid!,
        subcollection: 'items',
        subdoc: data.id,
        data: data.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getCategories() async {
    try {
      final snapshot = await _service.getAll(
        collection: _collection,
        doc: Globals.uid!,
        subcollection: 'categories',
      );

      categories = snapshot.map((e) => CategoryEntity.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createCategory(CategoryEntity category) async {
    try {
      await _service.add(
        collection: _collection,
        doc: Globals.uid!,
        subcollection: 'categories',
        subdoc: category.id,
        data: category.toJson(),
      );

      categories.add(category);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getLibrary() async {
    try {
      final data = await _service.getAll(
        collection: _collection,
        doc: Globals.uid!,
        subcollection: 'items',
      );

      content = data.map((e) => LibraryEntity.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  List<LibraryEntity> filterByCategory(
    String? categoryId,
  ) {
    if (categoryId == null || categoryId == 'all') return content;
    return content.where((e) => e.categoryId == categoryId).toList();
  }

  Future<void> deleteCategory(String categoryId, BuildContext context) async {
    try {
      await _service.delete(
        collection: _collection,
        doc: Globals.uid!,
        subcollection: 'categories',
        subdoc: categoryId,
      );
      categories.removeWhere((e) => e.id == categoryId);
      if (context.mounted) {
        HitagiToast.show(
          context,
          message: 'Categoria excluída com sucesso.',
          type: ToastType.success,
        );
        context.pop();
      }
      notifyListeners();
    } catch (e) {
      Logger().e('Erro ao excluir categoria: $e');
      if (context.mounted) {
        HitagiToast.show(
          context,
          message: 'Erro ao excluir categoria.',
          type: ToastType.error,
        );
      }
      rethrow;
    }
  }

  Future<void> delete(String id, BuildContext context) async {
    try {
      await _service.delete(
        collection: _collection,
        doc: Globals.uid!,
        subcollection: 'items',
        subdoc: id,
      );
      if (context.mounted) {
        HitagiToast.show(
          context,
          message: 'Item excluído com sucesso.',
          type: ToastType.success,
        );
        context.pop();
      }
      content.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      Logger().e('Erro ao excluir item: $e');
      if (context.mounted) {
        HitagiToast.show(
          context,
          message: 'Erro ao excluir item.',
          type: ToastType.error,
        );
      }
      rethrow;
    }
  }
}
