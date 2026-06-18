import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'kharchabook.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        categoryIcon TEXT NOT NULL,
        note TEXT,
        date TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon TEXT NOT NULL,
        color TEXT NOT NULL
      )
    ''');
    final cats = [
      {'name': 'Food',      'icon': '🍔', 'color': 'FF6584'},
      {'name': 'Transport', 'icon': '🚗', 'color': '3A86FF'},
      {'name': 'Bills',     'icon': '💡', 'color': 'FFBE0B'},
      {'name': 'Health',    'icon': '💊', 'color': '43C6AC'},
      {'name': 'Shopping',  'icon': '🛍️', 'color': '6C63FF'},
      {'name': 'Salary',    'icon': '💰', 'color': '00C897'},
      {'name': 'Other',     'icon': '📦', 'color': 'FF006E'},
    ];
    for (final c in cats) await db.insert('categories', c);
  }
}