import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DataBaseService {
  openDB() async {
    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'wefly_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE alertes(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
        );
      },
    );
    return database;
  }
}
