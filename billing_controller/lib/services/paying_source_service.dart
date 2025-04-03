import '../config/database_config.dart';
import '../model/paying_source.dart';

class PayingSourceService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> createPayingSource(PayingSource source) async {
    final db = await _dbHelper.database;
    return await db.insert('fonte_pagadora', {
      'nome': source.name,
      'saldo': source.balance,
      'intent_android': source.intentAndroid,
      'intent_ios': source.intentIos,
    });
  }

  Future<List<PayingSource>> getAllPayingSources() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('fonte_pagadora');

    return List.generate(maps.length, (i) {
      return PayingSource(
        id: maps[i]['id'],
        name: maps[i]['nome'],
        balance: maps[i]['saldo'],
        intentAndroid: maps[i]['intent_android'],
        intentIos: maps[i]['intent_ios'],
      );
    });
  }

  Future<PayingSource?> getPayingSourceById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'fonte_pagadora',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return PayingSource(
        id: result[0]['id'],
        name: result[0]['nome'],
        balance: result[0]['saldo'],
        intentAndroid: result[0]['intent_android'],
        intentIos: result[0]['intent_ios'],
      );
    }
    return null;
  }

  // Atualiza uma fonte pagadora existente
  Future<int> updatePayingSource(PayingSource source) async {
    final db = await _dbHelper.database;
    return await db.update(
      'fonte_pagadora',
      {
        'nome': source.name,
        'saldo': source.balance,
        'intent_android': source.intentAndroid,
        'intent_ios': source.intentIos,
      },
      where: 'id = ?',
      whereArgs: [source.id],
    );
  }

  // Remove uma fonte pagadora
  Future<int> deletePayingSource(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('fonte_pagadora', where: 'id = ?', whereArgs: [id]);
  }

  // Método adicional: Busca por nome (opcional)
  Future<List<PayingSource>> searchPayingSourcesByName(String name) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'fonte_pagadora',
      where: 'nome LIKE ?',
      whereArgs: ['%$name%'],
    );

    return List.generate(maps.length, (i) {
      return PayingSource(
        id: maps[i]['id'],
        name: maps[i]['nome'],
        balance: maps[i]['saldo'],
        intentAndroid: maps[i]['intent_android'],
        intentIos: maps[i]['intent_ios'],
      );
    });
  }
}
