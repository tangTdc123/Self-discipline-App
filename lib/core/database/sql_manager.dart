import 'dart:ffi';

import 'package:quit_product/utils/object_util.dart';
import 'package:sqflite/sqflite.dart';

class SqlManager{
  static const _Version = 1;
  static const _DB_NAME="root,db";
  static Database? _database;
  //初始化database对象

  static init() async{
      String dbPath = await getDatabasesPath() + "/$_DB_NAME";
      _database = await openDatabase(dbPath,version: _Version,onCreate: (db, version) => {},);
  }
  //获取当前数据库对象，第一次获取没有创建则创建

  static Future<Database> getCurrentDataBase() async {
    if(_database ==null){
      await init();
    }
    return _database!;
  }

  //判断表是否存在
  static Future<bool> isTableExits(String tableName) async {
    await getCurrentDataBase();
    var res = await _database?.rawQuery(
        "select * from sqlite_master where type = 'table' and name = '$tableName'");

    return !ObjectUtil.isEmptyList(res);
  }

    //关闭数据库
  static void close() {
    _database?.close();
    _database = null;
  }

}