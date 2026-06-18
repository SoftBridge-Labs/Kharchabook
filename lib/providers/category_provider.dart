import 'package:flutter/material.dart';
import '../data/models/category_model.dart';
import '../data/repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final _repo = CategoryRepository();
  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  Future<void> load() async {
    _categories = await _repo.getAll();
    notifyListeners();
  }

  Future<void> add(CategoryModel c) async {
    await _repo.insert(c);
    await load();
  }

  Future<void> delete(int id) async {
    await _repo.delete(id);
    await load();
  }
}