import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';

import 'object_util.dart';

String formatter_1 = "yyyy.MM.dd HH:mm:ss";
String formatter_2 = "yyyy.MM.dd HH:mm";


TimeOfDay? stringConvertToTimeOfDay(String? string) {
  if (ObjectUtil.isEmptyString(string)) return null;

  List<String> items = string!.split(":");
  if (ObjectUtil.isEmptyList(items)) return null;

  if (items.length != 2) return null;

  TimeOfDay? timeOfDay;
  try {
    timeOfDay =
        TimeOfDay(hour: int.parse(items[0]), minute: int.parse(items[1]));
  } catch (e) {
    timeOfDay = null;
  }
  return timeOfDay;
}

String? timeOfDayConvertToString(TimeOfDay? timeOfDay) {
  if (timeOfDay == null) return null;

  String? hourString;
  if (timeOfDay.hour < 10) {
    hourString = "0" + "${timeOfDay.hour}";
  } else {
    hourString = "${timeOfDay.hour}";
  }

  String? minuteString;
  if (timeOfDay.minute < 10) {
    minuteString = "0" + "${timeOfDay.minute}";
  } else {
    minuteString = "${timeOfDay.minute}";
  }

  return hourString + ":" + minuteString;
}

String? formatTime({String? formatter, DateTime? time}) {
  if (time == null) return null;

  String formatterString =
      ObjectUtil.isEmptyString(formatter) ? formatter_1 : formatter!;

  var dateFormatter = new DateFormat(formatterString);

  return dateFormatter.format(time);
}

DateTime? stringToDateTime(String dateString) {
  String formattedString = dateString.replaceAll(".", "-");

  DateTime? dateTime;
  try {
    dateTime = DateTime.parse(formattedString);
  } catch (e) {
    dateTime = null;
  }
  return dateTime;
}

//计算两个日期相差多少天
int diffdaysBetweenTwoDate(DateTime startDate, DateTime endDate) {
  return endDate.difference(startDate).inDays;
}

/// 秒转天时分秒
String second2DHMS(int sec) {
  String hms = "00${'days'.tr}00${'hours'.tr}00${'mins'.tr}00${'secs'.tr}";
  if (sec > 0) {
    int d = sec ~/ 86400;
    int h = (sec % 86400) ~/ 3600;
    int m = (sec % 3600) ~/ 60;
    int s = sec % 60;
    hms = "${zeroFill(d)}${'days'.tr}${zeroFill(h)}${'hours'.tr}${zeroFill(m)}${'mins'.tr}${zeroFill(s)}${'secs'.tr}";
  }
  return hms;
}

///补零
String zeroFill(int i) {
  return i >= 10 ? "$i" : "0$i";
}
