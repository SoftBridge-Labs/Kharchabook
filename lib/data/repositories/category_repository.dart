import '../database/db_helper.dart';
import '../models/category_model.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getAll() async {
    final db = await DBHelper.database;
    final maps = await db.query('categories');
    return maps.map(CategoryModel.fromMap).toList();
  }

  Future<int> insert(CategoryModel c) async {
    final db = await DBHelper.database;
    return db.insert('categories', c.toMap());
  }

  Future<int> delete(int id) async {
    final db = await DBHelper.database;
    return db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
}