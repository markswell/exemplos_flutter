import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'billing_controller.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE fonte_pagadora (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        saldo REAL NOT NULL,
        intent_android TEXT,
        intent_ios TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE conta (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        valor REAL NOT NULL,
        data_vencimento TEXT NOT NULL,
        data_pagamento TEXT,
        valor_pago REAL,
        id_fonte_pagadora INTEGER,
        ordem INTEGER,
        FOREIGN KEY (id_fonte_pagadora) REFERENCES fonte_pagadora (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE ordem_conta (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ordem_value INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      INSERT INTO ordem_conta (ordem_value) VALUES (1);
    ''');
  }
}
