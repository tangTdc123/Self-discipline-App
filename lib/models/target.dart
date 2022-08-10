
import 'package:flutter/material.dart';
import 'package:quit_product/utils/date_time.dart';
import 'package:quit_product/utils/object_util.dart';

enum TargetStatus { processing, completed, giveuped }

class Target {
  int? id;
  String? name;
  String? description;

  int? targetDays;
  Color? targetColor;

  //声音
  String? soundKey;

  List<TimeOfDay>? notificationTimes;

  DateTime? createTime;

  DateTime? giveUpTime;

  TargetStatus? targetStatus;

  Target clone() {
    return Target()
      ..id = id
      ..name = name
      ..description = description
      ..targetDays = targetDays
      ..targetColor = targetColor
      ..soundKey = soundKey
      ..notificationTimes = List.from(notificationTimes ?? [])
      ..createTime = createTime
      ..giveUpTime = giveUpTime
      ..targetStatus = targetStatus;
  }

  static Target generateTargetCurrentStatus(Target target) {
    if (target.targetStatus == null ||
        target.targetStatus == TargetStatus.processing) {
      //判断target状态
      TargetStatus? targetStatus;

      //判断目标是否已经完成
      DateTime completedTime =
          target.createTime!.add(Duration(days: target.targetDays!));
      if (DateTime.now().isBefore(completedTime)) {
        targetStatus = TargetStatus.processing;
      } else {
        targetStatus = TargetStatus.completed;
      }

      Target newTarget = target.clone();
      newTarget.targetStatus = targetStatus;
      return newTarget;
    }

    return target.clone();
  }

  static Target? targetFromMap(Map<String, dynamic> map) {
    if (ObjectUtil.isEmptyMap(map)) return null;
    String? notificationTimeString = map["t_notification_time"];

    List<TimeOfDay>? times;
    if (!ObjectUtil.isEmptyString(notificationTimeString)) {
      List<String> items = notificationTimeString!.split("|");
      if (!ObjectUtil.isEmptyList(items)) {
        times = [];
        items.forEach((element) {
          TimeOfDay? timeOfDay = stringConvertToTimeOfDay(element);
          if (timeOfDay != null) {
            times!.add(timeOfDay);
          }
        });
      }
    }

    Color? color;
    String? colorString = map["t_colors"];
    if (!ObjectUtil.isEmptyString(colorString)) {
      List<String> items = colorString!.split("|");
      if (!ObjectUtil.isEmptyList(items) && items.length == 3) {
        try {
          color = Color.fromRGBO(
              int.parse(items[0]), int.parse(items[1]), int.parse(items[2]), 1);
        } catch (e) {
          color = null;
        }
      }
    }

    String soundKey = map["t_sound_key"];

    String createTimeString = map["t_createtime"];
    DateTime? createTime = stringToDateTime(createTimeString);

    //判断target状态
    TargetStatus? targetStatus;
    DateTime? giveUpDate;
    // String giveupTime = map["t_giveuptime"];
    if (map["t_giveuptime"] != null) {
      targetStatus = TargetStatus.giveuped;
      String time = map["t_giveuptime"];
      giveUpDate = stringToDateTime(time);
    } else {
      //判断目标是否已经完成
      DateTime completedTime =
          createTime!.add(Duration(days: map["t_days"] as int));
      if (DateTime.now().isBefore(completedTime)) {
        targetStatus = TargetStatus.processing;
      } else {
        targetStatus = TargetStatus.completed;
      }
    }

    return Target()
      ..id = map["id"] as int
      ..name = map["t_name"] as String
      ..targetDays = map["t_days"] as int
      ..targetColor = color
      ..soundKey = soundKey
      ..notificationTimes = times
      ..createTime = createTime
      ..giveUpTime = giveUpDate
      ..targetStatus = targetStatus;
  }
}
