import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Database db;
    if (kIsWeb) {
      // Use web-specific IndexedDB database factory
      final factory = databaseFactoryWeb;
      db = await factory.openDatabase('card_due.db');
    } else {
      // Use IO database factory for local file storage
      final dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      final dbPath = p.join(dir.path, 'card_due.db');
      final factory = databaseFactoryIo;
      db = await factory.openDatabase(dbPath);
    }
    return db;
  }
}
