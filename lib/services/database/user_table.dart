import 'package:flutter/material.dart';
import 'package:querybuildertask/models/user_model.dart';
import 'package:querybuildertask/services/database/database_config.dart';
import 'package:querybuildertask/services/database/database_service.dart';
import 'package:querybuildertask/services/database/query_builder.dart';
import 'package:querybuildertask/view/pages/user_list.dart';
import 'package:sqflite/utils/utils.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserTable extends BaseTable {
  UserTable(String tableName) : super(tableName);

  // add user
  void addUser(User user) {
    Map<String, dynamic> data = user.toJson();
    data.remove('id');
    _insert(data);
  }

  // update the record
  Future<int> updateUserRecord(User user) {
    return _update(user.toJson());
  }

  // fetch all user
  Future<List<User>> fetchAllUser() async {
    List<Map> data = await _fetchAllRecords();
    return data.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }

  // fetch single user
  Future<User> fetchSingleUser(int id) async {
    List<Map<String, Object?>> data = await _fetchSingleRecord(id);
    return User.fromJson(data[0]);
  }

  // delete the user table
  void deleteUserTable() {
    _deleteUserTable();
  }

  //
  void batchInsert(BuildContext context, int numberOfUsers) {
    List<Map<String, dynamic>> userList = [];
    for (int i = 1; i <= numberOfUsers; i++) {
      Map<String, dynamic> user = {
        "name": 'Micromerger' + i.toString(),
        "country": "Pakistan",
        "city": "Rawalpindi",
        'cnic': '${i}8494-8284849-$i',
        "address": "Micromerger I-9",
        "age": i.toString(),
        "updatedDate": (DateTime.now().millisecondsSinceEpoch + i),
        "createdDate": (DateTime.now().millisecondsSinceEpoch + i)
      };
      userList.add(user);
    }
    _batchInsert(userList, context);
  }
}

// this base class
class BaseTable {
  String? _tableName;
  BaseTable(String table) {
    _tableName = table;
  }

  void _batchInsert(
      List<Map<String, dynamic>> userList, BuildContext context) async {
    try {
      Database? db = await DatabaseService.instance.database;
      Batch batch = db!.batch();
      DateTime startTime = (DateTime.now());
      for (Map<String, dynamic> data in userList) {
        batch.insert(_tableName!, data);
      }
      await batch.commit(noResult: true);
      DateTime endTime = (DateTime.now());
      showAlertDialog(context, (endTime.difference(startTime).inSeconds));
    } catch (e) {
      throw Exception(e);
    }
  }

  // insert  records
  Future<int> _insert(Map<String, dynamic> data) async {
    String queryBuilt = QueryBuilder.insertQueryBuilder(data);
    try {
      Database? db = await DatabaseService.instance.database;
      String sql = 'INSERT INTO $_tableName $queryBuilt';
      //'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)'
      int id = await db!.rawInsert(sql);
      return id;
    } catch (e) {
      throw Exception(e);
    }
  }

  // update the record
  Future<int> _update(Map<String, dynamic> data) async {
    Database? db = await DatabaseService.instance.database;
    List values = data.values.toList();
    String subSet = QueryBuilder.updateRecordQueryBuilder(data);
    String sql = 'UPDATE $_tableName SET $subSet WHERE id = ?';
    int updateCount = await db!.rawUpdate(sql, [...values, values.first]);
    return updateCount;
  }

  // fetch all records
  Future<List<Map>> _fetchAllRecords() async {
    try {
      Database? db = await DatabaseService.instance.database;
      String sql = 'SELECT * FROM $_tableName ORDER BY createdDate DESC';
      return await db!.rawQuery(sql);
    } catch (e) {
      throw Exception(e);
    }
  }

  // fetch single record
  Future<List<Map<String, Object?>>> _fetchSingleRecord(int userId) async {
    try {
      Database? db = await DatabaseService.instance.database;
      String sql = 'SELECT * FROM $_tableName WHERE id = $userId';
      return await db!.rawQuery(sql);
    } catch (e) {
      throw Exception(e);
    }
  }

  // delete User Table

  Future<void> _deleteUserTable() async {
    try {
      Database? db = await DatabaseService.instance.database;
      await db!.transaction((txn) async {
        var batch = txn.batch();
        batch.delete(_tableName!);
        await batch.commit();
      });
    } catch (error) {
      throw Exception('DbBase.cleanDatabase: ' + error.toString());
    }
  }

  Future _deleteDataBase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DatabaseConfig.databaseName);
    return await deleteDatabase(path);
  }

  // schema information

  //Check if a table exists
  Future<bool> tableExists(DatabaseExecutor db, String table) async {
    var count = firstIntValue(await db.query('sqlite_master',
        columns: ['COUNT(*)'],
        where: 'type = ? AND name = ?',
        whereArgs: ['table', table]));
    return count! > 0;
  }

  // List table names
  Future<List<String>> getTableNames(DatabaseExecutor db) async {
    var tableNames = (await db
            .query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name'] as String)
        .toList(growable: false)
      ..sort();
    return tableNames;
  }

  showAlertDialog(BuildContext context, int diffInSeconds) {
    // Create button
    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const UserProfileListing(),
          ),
        );
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Execution Time"),
      content: Text((diffInSeconds.toString() + ' seconds')),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
