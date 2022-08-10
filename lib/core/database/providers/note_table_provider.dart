

import 'package:quit_product/core/database/providers/base_table_provider.dart';
import 'package:quit_product/models/note.dart';
import 'package:quit_product/utils/date_time.dart';
import 'package:sqflite/sqlite_api.dart';

class NoteTableProvider extends BaseTableProvider {
  //表名
  final String tablename = "note";

  //表列名
  final String columnId = "id";
  final String columnTargetId = "target_id";
  final String columnNote = "note";
  final String columnCreateTime = "n_createtime";

  @override
  String createTableString() {
    return '''CREATE TABLE $tablename (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $columnTargetId INTEGER NOT NULL, 
      $columnNote TEXT NOT NULL, 
      $columnCreateTime TEXT NOT NULL)''';
  }

  @override
  String tableName() {
    return tablename;
  }

  Future insertNote(Note note) async {
    Database db = await getDataBase();

    int targetId = note.targetId!;
    String noteText = note.note!;

    String createTime =
        formatTime(formatter: formatter_1, time: note.createTime!)!;

    return await db.transaction((txn) async {
      int rowid = await txn.rawInsert(
          'INSERT INTO $tablename($columnTargetId, $columnNote, $columnCreateTime) VALUES($targetId, "$noteText", "$createTime")');
      return rowid;
    });
  }

  Future<List<Map<String, dynamic>>> queryNotes({required int targetId}) async {
    Database db = await getDataBase();
    String sql =
        "SELECT * FROM $tablename WHERE $columnTargetId = $targetId ORDER BY $columnCreateTime";

    List<Map<String, dynamic>> results = await db.rawQuery(sql);
    return results;
  }
}
