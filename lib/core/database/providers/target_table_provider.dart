import 'dart:math';

import 'package:quit_product/core/database/providers/base_table_provider.dart';
import 'package:quit_product/models/target.dart';
import 'package:quit_product/pages/tabs/main/main_controller.dart';
import 'package:quit_product/utils/date_time.dart';
import 'package:quit_product/utils/object_util.dart';
import 'package:sqflite/sqlite_api.dart';

class TargetTableProvider extends BaseTableProvider {
  //表名
  final String tablename = "target";

  //表列名
  final String columnId = "id";
  final String columnTargetName = "t_name";
  final String columnTargetDays = "t_days";
  final String columnTargetColors = "t_colors";
  final String columnTargetSoundKey = "t_sound_key";
  final String columnTargetNotificationTimes = "t_notification_time";
  final String columnTargetCreateTime = "t_createtime";
  final String columnTargetDeleteTime = "t_deletetime";
  final String columnTargetGiveUpTime = "t_giveuptime";

  //test
  @override
  String createTableString() {
    return '''CREATE TABLE $tablename (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $columnTargetName TEXT NOT NULL, 
      $columnTargetDays INTEGER NOT NULL, 
      $columnTargetColors TEXT, 
      $columnTargetSoundKey TEXT NOT NULL, 
      $columnTargetNotificationTimes TEXT, 
      $columnTargetCreateTime TEXT NOT NULL, 
      $columnTargetDeleteTime TEXT,
      $columnTargetGiveUpTime TEXT)''';
  }

  @override
  String tableName() {
    return tablename;
  }

  //查询创建的目标，分页
  Future<List<Map<String, dynamic>>> queryTargets(
      {FilterType? filterType, int? page, int? pagecount}) async {
    Database db = await getDataBase();

    String? sql;

    if (filterType != null && filterType == FilterType.giveup) {
      //放弃的目标
      sql =
          "SELECT * FROM $tablename WHERE $columnTargetGiveUpTime IS NOT NULL ORDER BY $columnTargetCreateTime DESC";
    } else if (filterType != null &&
        (filterType == FilterType.processing ||
            filterType == FilterType.completed)) {
      //进行中或已完成
      //其他筛选状态查询全部，在程序中处理，因为sqlite的日期比较函数不强大
      sql =
          "SELECT * FROM $tablename WHERE $columnTargetGiveUpTime IS NULL ORDER BY $columnTargetCreateTime DESC";
    } else {
      //查询全部
      sql = "SELECT * FROM $tablename ORDER BY $columnTargetCreateTime DESC";
    }

    if (page != null && pagecount != null) {
      int from = (page - 1) * pagecount;
      // int offset = pagecount - 1;

      sql = sql + "LIMIT $from, $pagecount";
    }

    List<Map<String, dynamic>> results = await db.rawQuery(sql);
    return results;
  }

  //插入新的目标
  Future insertTarget(Target? target) async {
    if (target != null) {
      Database db = await getDataBase();

      String name = target.name!;
      int days = target.targetDays!;
      String? colors = target.targetColor == null
          ? null
          : "${target.targetColor!.red}|${target.targetColor!.green}|${target.targetColor!.blue}";

      String soundKey = target.soundKey!;

      String? notificationTimes;

      if (target.notificationTimes != null) {
        String times = "";
        for (int i = 0; i < target.notificationTimes!.length; i++) {
          times += timeOfDayConvertToString(target.notificationTimes![i])!;
          if (i < target.notificationTimes!.length - 1) {
            times += "|";
          }
        }
        notificationTimes = times;
      }

      DateTime now = DateTime.now();

      String nowString = formatTime(formatter: formatter_1, time: now)!;

      return await db.transaction((txn) async {
        int rowid = await txn.rawInsert(
            'INSERT INTO $tablename($columnTargetName, $columnTargetDays, $columnTargetColors, $columnTargetSoundKey ,$columnTargetNotificationTimes, $columnTargetCreateTime) VALUES("$name", "$days", "$colors", "$soundKey" ,"$notificationTimes", "$nowString")');
        return {'rowid': rowid, 'createTime': now};
      });
    }
  }

  Future updateTarget(Target target) async {
    //只能更新颜色，通知时间, 声音
    Database db = await getDataBase();
    String? colors = target.targetColor == null
        ? null
        : "${target.targetColor!.red}|${target.targetColor!.green}|${target.targetColor!.blue}";
    String? notificationTimes;

    if (target.notificationTimes != null) {
      String times = "";
      for (int i = 0; i < target.notificationTimes!.length; i++) {
        times += timeOfDayConvertToString(target.notificationTimes![i])!;
        if (i < target.notificationTimes!.length - 1) {
          times += "|";
        }
      }
      notificationTimes = times;
    }

    String soundKey = target.soundKey!;

    return await db.transaction((txn) async {
      int count = await txn.rawUpdate(
          'UPDATE $tablename SET $columnTargetColors = ?, $columnTargetSoundKey = ?, $columnTargetNotificationTimes = ? WHERE $columnId = ?',
          [colors, soundKey, notificationTimes, target.id]);
      return count;
    });
  }

  //放弃某个目标
  Future giveupTarget(Target target) async {
    Database db = await getDataBase();

    String now = formatTime(formatter: formatter_1, time: DateTime.now())!;

    return await db.transaction((txn) async {
      int count = await txn.rawUpdate(
          'UPDATE $tablename SET $columnTargetGiveUpTime = ? WHERE $columnId = ?',
          [now, target.id]);
      return count;
    });
  }

  //根据目标名查询目标
  Future<List<Target>> queryTargetsByName(String name) async {
    Database db = await getDataBase();

    //筛选出当前目标名，正在进行或者已经完成的目标
    String sql =
        "SELECT * FROM $tablename WHERE $columnTargetGiveUpTime IS NULL AND $columnTargetName = ?";

    List<Map<String, dynamic>> results = await db.rawQuery(sql, [name]);

    List<Target> targets = [];

    if (!ObjectUtil.isEmptyList(results)) {
      results.forEach((element) {
        if (!ObjectUtil.isEmptyMap(element)) {
          Target? target = Target.targetFromMap(element);
          if (target != null) {
            targets.add(target);
          }
        }
      });
    }

    return targets;
  }
  //删除某条目标 TODO

  //修改某条目标 TODO

}
