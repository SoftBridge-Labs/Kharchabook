import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  Future<int> insert(TransactionModel t) async {
    final db = await DBHelper.database;
    return db.insert('transactions', t.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TransactionModel>> getAll() async {
    final db = await DBHelper.database;
    final maps = await db.query('transactions', orderBy: 'date DESC');
    return maps.map(TransactionModel.fromMap).toList();
  }

  Future<List<TransactionModel>> getByMonth(int month, int year) async {
    final db = await DBHelper.database;
    final all = await db.query('transactions', orderBy: 'date DESC');
    return all
        .map(TransactionModel.fromMap)
        .where((t) => t.date.month == month && t.date.year == year)
        .toList();
  }

  Future<int> update(TransactionModel t) async {
    final db = await DBHelper.database;
    return db.update('transactions', t.toMap(),
        where: 'id = ?', whereArgs: [t.id]);
  }

  Future<int> delete(int id) async {
    final db = await DBHelper.database;
    return db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}