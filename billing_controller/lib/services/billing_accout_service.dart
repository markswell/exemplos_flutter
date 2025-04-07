import '../config/database_config.dart';
import '../model/billing_account.dart';
import '../model/paying_source.dart';
import 'ordem_servie.dart';

class BillingAccountService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> createBillingAccount(BillingAccount account) async {
    final db = await _dbHelper.database;
    var newOrdemValue = await OrdemService().getNewOrdem();
    var id = await db.insert('conta', {
      'nome': account.name,
      'valor': account.value,
      'data_vencimento': account.dueDate.toIso8601String(),
      'data_pagamento': account.paymentDate,
      'valor_pago': account.paymentValue,
      'id_fonte_pagadora': account.payingSource?.id,
      'ordem': newOrdemValue,
    });
    return id;
  }

  Future<List<BillingAccount>> getBillingAccounts() async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT c.*, f.nome as fonte_nome, f.saldo as fonte_saldo, 
           f.intent_android, f.intent_ios
    FROM conta c
    LEFT JOIN fonte_pagadora f ON c.id_fonte_pagadora = f.id
    ORDER BY c.ordem
  ''');

    return List.generate(maps.length, (i) {
      return BillingAccount(
        id: maps[i]['id'],
        name: maps[i]['nome'],
        value: maps[i]['valor'],
        dueDate: DateTime.parse(maps[i]['data_vencimento']),
        paymentDate: maps[i]['data_pagamento'],
        paymentValue: maps[i]['valor_pago'],
        order: maps[i]['ordem'],
        payingSource:
            maps[i]['id_fonte_pagadora'] != null
                ? PayingSource(
                  id: maps[i]['id_fonte_pagadora'],
                  name: maps[i]['fonte_nome'],
                  balance: maps[i]['fonte_saldo'],
                  intentAndroid: maps[i]['intent_android'],
                  intentIos: maps[i]['intent_ios'],
                )
                : null,
      );
    });
  }

  Future<BillingAccount?> getBillingAccount(int id) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
    SELECT c.*, f.nome as fonte_nome, f.saldo as fonte_saldo, 
           f.intent_android, f.intent_ios
    FROM conta c
    LEFT JOIN fonte_pagadora f ON c.id_fonte_pagadora = f.id
    WHERE c.id = ?
    LIMIT 1
  ''',
      [id],
    );

    if (result.isNotEmpty) {
      return BillingAccount(
        id: result[0]['id'],
        name: result[0]['nome'],
        value: result[0]['valor'],
        dueDate: DateTime.parse(result[0]['data_vencimento']),
        paymentDate: result[0]['data_pagamento'],
        paymentValue: result[0]['valor_pago'],
        order: result[0]['ordem'],
        payingSource:
            result[0]['id_fonte_pagadora'] != null
                ? PayingSource(
                  id: result[0]['id_fonte_pagadora'],
                  name: result[0]['fonte_nome'],
                  balance: result[0]['fonte_saldo'],
                  intentAndroid: result[0]['intent_android'],
                  intentIos: result[0]['intent_ios'],
                )
                : null,
      );
    }
    return null;
  }

  Future<int> updateBillingAccount(BillingAccount account) async {
    final db = await _dbHelper.database;
    return await db.update(
      'conta',
      {
        'nome': account.name,
        'valor': account.value,
        'data_vencimento': account.dueDate.toIso8601String(),
        'data_pagamento': account.paymentDate?.toIso8601String() ?? null,
        'valor_pago': account.paymentValue,
        'id_fonte_pagadora': account.payingSource?.id,
        'ordem': account.order,
      },
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  Future<int> deleteBillingAccount(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('conta', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<BillingAccount>> getAccountsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
    SELECT c.*, f.nome as fonte_nome, f.saldo as fonte_saldo, 
           f.intent_android, f.intent_ios
    FROM conta c
    LEFT JOIN fonte_pagadora f ON c.id_fonte_pagadora = f.id
    WHERE c.data_vencimento BETWEEN ? AND ?
    ORDER BY c.ordem
  ''',
      [start.toIso8601String(), end.toIso8601String()],
    );

    return List.generate(maps.length, (i) {
      return BillingAccount(
        id: maps[i]['id'],
        name: maps[i]['nome'],
        value: maps[i]['valor'],
        dueDate: DateTime.parse(maps[i]['data_vencimento']),
        paymentDate:
            maps[i]['data_pagamento'] != null
                ? DateTime.parse(maps[i]['data_pagamento'])
                : null,
        paymentValue: maps[i]['valor_pago'],
        order: maps[i]['ordem'],
        payingSource:
            maps[i]['id_fonte_pagadora'] != null
                ? PayingSource(
                  id: maps[i]['id_fonte_pagadora'],
                  name: maps[i]['fonte_nome'],
                  balance: maps[i]['fonte_saldo'],
                  intentAndroid: maps[i]['intent_android'],
                  intentIos: maps[i]['intent_ios'],
                )
                : null,
      );
    });
  }
}
