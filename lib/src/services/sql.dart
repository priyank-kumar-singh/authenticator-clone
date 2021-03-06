import 'package:sqflite/sqflite.dart';
import '../models/app.dart';

class SQLDatabase {
  static const _database = 'authenticator.db';
  static const _table1 = 'mfa_applications';
  static const _version = 1;

  static late Database _db;

  static Future<SQLDatabase> getInstance() async {
    // ignore: prefer_adjacent_string_concatenation
    var sql = 'CREATE TABLE $_table1 (' +
        'uid INTEGER PRIMARY KEY AUTOINCREMENT,' +
        'type TEXT, user TEXT, secret TEXT,' +
        'issuer TEXT, algorithm TEXT, digits TEXT,' +
        'counter TEXT, period TEXT )';

    _db = await openDatabase(_database, version: _version, onCreate: (db, version) async {
      await db.execute(sql);
    });

    return SQLDatabase._();
  }

  SQLDatabase._();

  Future<int> add(MFA_Apps item) async {
    var data = item.toMap();
    return await _db.insert(_table1, data);
  }

  Future<List<MFA_Apps>> getOne(MFA_Apps item) async {
    var query = 'SELECT * FROM $_table1 WHERE user="${item.user}" AND secret="${item.secret}" AND issuer="${item.issuer}"';
    var data = await _db.rawQuery(query);
    return data.map((e) => MFA_Apps.fromMap(e)).toList();
  }

  Future<List<MFA_Apps>> getAll() async {
    var query = 'SELECT * FROM $_table1';
    var data = await _db.rawQuery(query);
    return data.map((e) => MFA_Apps.fromMap(e)).toList();
  }

  Future<void> delete(int id) async {
    var query = 'DELETE FROM $_table1 WHERE uid = ?';
    await _db.rawDelete(query, [id]);
  }
}

late SQLDatabase sqlDatabase;
