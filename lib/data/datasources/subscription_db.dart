import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:subsight/features/subscription/models/subscription_model.dart';

class SubscriptionDB {
  static const _dbName = 'subsight.db';
  static const _dbVersion = 1;
  static const _tableName = 'subscriptions';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final documentsDirectory = await getApplicationSupportDirectory();
    final path = join(documentsDirectory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        billingCycle TEXT NOT NULL,
        category TEXT NOT NULL,
        nextPayment TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertSubscription(SubscriptionModel sub) async {
    final db = await database;
    return await db.insert(_tableName, sub.toMap());
  }

  Future<List<SubscriptionModel>> getLocalSubscriptions() async {
    final db = await database;
    final result = await db.query(_tableName, orderBy: 'nextPayment ASC');
    return result.map((e) => SubscriptionModel.fromMap(e)).toList();
  }

  Future<void> removeSubscription(int id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateSubscription(SubscriptionModel sub) async {
    final db = await database;
    await db.update(
      _tableName,
      sub.toMap(),
      where: 'id = ?',
      whereArgs: [sub.id],
    );
  }

  Future<void> close() async {
    final db = await database;
    if (db.isOpen) {
      await db.close();
    }
  }
}
