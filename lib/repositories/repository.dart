import 'package:rental_z/repositories/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  DatabaseConnection? _databaseConnection;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _databaseConnection!.setDatabase();
    return _database;
  }

  // Insert data
  insertData(table, data) async {
    Database? db = await database;
    return await db!.insert(table, data);
  }

  // Get all data from database
  getAllData(table) async {
    Database? db = await database;
    return await db!.query(table);
  }

  // Get data from database by id
  getDataById(table, id) async {
    Database? db = await database;
    return await db!.query(table, where: 'id = ?', whereArgs: [id]);
  }

  // Update data from database by id
  updateData(table, data, id) async {
    Database? db = await database;
    return await db!.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  // Delete data from database by id
  deleteData(table, id) async {
    Database? db = await database;
    return await db!.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
