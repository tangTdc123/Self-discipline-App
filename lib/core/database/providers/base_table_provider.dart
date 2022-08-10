
import 'package:quit_product/core/database/sql_manager.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class BaseTableProvider {
  String tableName();

  String createTableString();

  Future<Database> getDataBase() async {
    bool isTableExist = await SqlManager.isTableExits(tableName());

    if (!isTableExist) {
      //表不存在，则创建表
      Database db = await SqlManager.getCurrentDataBase();
      await db.execute(createTableString());
      return db;
    } else {
      //表已经存在
      return await SqlManager.getCurrentDataBase();
    }
  }

  //创建表
  Future<void> createTable() async {
    bool isTableExist = await SqlManager.isTableExits(tableName());

    if (!isTableExist) {
      Database db = await SqlManager.getCurrentDataBase();
      await db.execute(createTableString());
    }
  }
}
