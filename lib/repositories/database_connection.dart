import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'rentalZ.db');
    var database = openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE houses(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, address TEXT, note TEXT, image TEXT, price INTEGER, reporter TEXT, room_type TEXT, bedroom_type TEXT, furniture_type TEXT, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)');

    await db.execute(
        'CREATE TABLE bedrooms(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, description TEXT, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)');

    await db.execute(
        'CREATE TABLE rooms(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, description TEXT, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)');

    await db.execute(
        'CREATE TABLE furnitures(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, description TEXT, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)');
  }
}
