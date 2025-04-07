import '../config/database_config.dart';

class OrdemService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> getNewOrdem() async {
    final db = await _dbHelper.database;
    var list = await db.rawQuery('''
      select max(ordem_value) as max_ordem from ordem_conta
    ''');
    var newOrdem = list.isNotEmpty ? (list[0]['max_ordem'] as int) + 1 : 0;
    _updateOrdem(newOrdem);
    return newOrdem;
  }

  Future<void> _updateOrdem(int newOrderNumber) async {
    final db = await _dbHelper.database;
    await db.rawUpdate(
      '''
      update ordem_conta set ordem_value = ?
    ''',
      [newOrderNumber],
    );
  }
}
