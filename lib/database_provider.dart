// ignore_for_file: depend_on_referenced_packages

import 'package:login_reg/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  String userTableName = "users";
  Future<Database> initializedDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'loginreg.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE $userTableName(id INTEGER PRIMARY KEY , name TEXT NOT NULL,email TEXT NOT NULL)",
        );
      },
    );
  }

  // insert data
  Future<int> insertUser(UserModel item) async {
    int result = 0;
    final Database db = await initializedDB();
    // for (var item in items) {
    result = await db.insert(userTableName, item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    // }
    return result;
  }

  // insert data
  Future<int> updateUserData(UserModel item, id) async {
    int result = 0;
    final Database db = await initializedDB();
    // for (var item in items) {
    result = await db.update(userTableName, item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: 'id = ?',
        whereArgs: [id]);
    // }
    return result;
  }

  // retrieve data
  Future<UserModel> retrieveUserFromTable() async {
    final Database db = await initializedDB();
    final List<Map<String, Object?>> queryResult =
        await db.query(userTableName);
    if (queryResult.isNotEmpty) {
      return queryResult.map((e) => UserModel.fromJson(e)).first;
    } else {
      return UserModel();
    }
  }

  // delete cart
  Future<void> deleteUserFromTable(int id) async {
    final db = await initializedDB();
    await db.delete(
      userTableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // clear db
  Future<void> cleanUserTable() async {
    final db = await initializedDB();
    await db.delete(
      userTableName,
    );
  }
}
