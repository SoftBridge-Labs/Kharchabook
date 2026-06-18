import 'package:flutter/material.dart';
import '../data/models/transaction_model.dart';
import '../data/repositories/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final _repo = TransactionRepository();
  List<TransactionModel> _all = [];
  List<TransactionModel> _monthly = [];
  bool _loading = false;

  List<TransactionModel> get all => _all;
  List<TransactionModel> get monthly => _monthly;
  bool get loading => _loading;

  double get totalIncome => _monthly
      .where((t) => t.type == 'income')
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => _monthly
      .where((t) => t.type == 'expense')
      .fold(0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  Future<void> loadAll() async {
    _loading = true;
    notifyListeners();
    _all = await _repo.getAll();
    _loading = false;
    notifyListeners();
  }

  Future<void> loadByMonth(int month, int year) async {
    _monthly = await _repo.getByMonth(month, year);
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel t) async {
    await _repo.insert(t);
    await loadAll();
    await loadByMonth(t.date.month, t.date.year);
  }

  Future<void> deleteTransaction(int id, DateTime date) async {
    await _repo.delete(id);
    await loadAll();
    await loadByMonth(date.month, date.year);
  }

  Map<String, double> get expenseByCategory {
    final Map<String, double> map = {};
    for (final t in _monthly.where((t) => t.type == 'expense')) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    return map;
  }
}