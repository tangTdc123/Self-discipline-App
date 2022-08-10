
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:quit_product/models/target.dart';

class NotificationManager {
  static void init() async {
    bool initialized = await AwesomeNotifications().initialize(
        'resource://drawable/res_power_ranger_thunder', //图片图层好像也有要求，透明之类的
        // null,
        //设置推送图标，ios 设置null, 默认为app icon，iOS好像只能设置成app icon; 安卓放在drawable文件夹下，以res_开头（安卓必须设置，否则在nexus等手机下显示有问题）
        [
          // NotificationChannel(
          //     channelKey: 'basic_channel',
          //     channelName: 'Basic notifications',
          //     channelDescription: 'Notification channel for basic tests',
          //     defaultColor: Color(0xFF9D50DD),
          //     ledColor: Colors.white,
          //     importance: NotificationImportance.High),
          NotificationChannel(
              // icon:
              //     'resource://drawable/res_power_ranger_thunder', //这个设置的是安卓状态栏上的通知图标，而不是悬浮窗的通知图标
              channelKey: 'lg-notifications',
              channelName: 'lg Notifications',
              // channelDescription:
              //     'Notification channel for target-notifications',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white, //推送时，可以设置手机背面LED的闪光颜色
              playSound: true,
              importance: NotificationImportance.High,
              soundSource: 'resource://raw/lg' //必须放在原生项目里。ios的后缀是aiff(mp3无效)
              ),
          NotificationChannel(
              channelKey: 'pikachu-notifications',
              channelName: 'pikachu Notifications',
              // channelDescription:
              //     'Notification channel for target-notifications',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white, //推送时，可以设置手机背面LED的闪光颜色
              playSound: true,
              importance: NotificationImportance.High,
              soundSource:
                  'resource://raw/pikachu' //必须放在原生项目里。ios的后缀是aiff(mp3无效)
              ),
          NotificationChannel(
              channelKey: 'ringtones-notifications',
              channelName: 'ringtones Notifications',
              // channelDescription:
              //     'Notification channel for target-notifications',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white, //推送时，可以设置手机背面LED的闪光颜色
              playSound: true,
              importance: NotificationImportance.High,
              soundSource:
                  'resource://raw/ringtones' //必须放在原生项目里。ios的后缀是aiff(mp3无效)
              ),
          NotificationChannel(
              channelKey: 'samsung-notifications',
              channelName: 'samsung Notifications',
              // channelDescription:
              //     'Notification channel for target-notifications',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white, //推送时，可以设置手机背面LED的闪光颜色
              playSound: true,
              importance: NotificationImportance.High,
              soundSource:
                  'resource://raw/samsung' //必须放在原生项目里。ios的后缀是aiff(mp3无效)
              ),
          NotificationChannel(
              channelKey: 'slow_spring_board-notifications',
              channelName: 'slow_spring_board Notifications',
              // channelDescription:
              //     'Notification channel for target-notifications',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white, //推送时，可以设置手机背面LED的闪光颜色
              playSound: true,
              importance: NotificationImportance.High,
              soundSource:
                  'resource://raw/slow_spring_board' //必须放在原生项目里。ios的后缀是aiff(mp3无效)
              ),
        ],
        debug: false);

    print(initialized);
  }

  static Future<void> createTargetNotification(Target? target) async {
    if (target != null && target.id != null) {
      List<TimeOfDay> notificationTimes = target.notificationTimes!;
      int? targetDays = target.targetDays;

      DateTime currentDate = DateTime.now();
      // currentDate.toUtc();

      DateTime completedTime =
          target.createTime!.add(Duration(days: target.targetDays!));

      if (targetDays != null) {
        for (int i = 0; i <= targetDays; i++) {
          //目标天数内，每天推送notificationTimes.length次
          notificationTimes.forEach((element) async {
            //element is TimeOfDay
            int hour = element.hour;
            int minute = element.minute;

            //每一个推送的id必须不同，否则后面设置的会覆盖前面的
            String idString = "${target.id}$hour$minute$i";

            DateTime nextDate = currentDate.add(Duration(days: i));

            DateTime scheduleTime = DateTime(
                nextDate.year, nextDate.month, nextDate.day, hour, minute);

            //注意，目标结束那天，目标结束后（创建时间+目标天数，到时分秒）的推送时间不要推送
            if (scheduleTime.isBefore(completedTime)) {
              await AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: int.parse(idString), //每一个推送的id必须不同，否则后面设置的会覆盖前面的
                    channelKey: '${target.soundKey}-notifications',
                    title: target.name!,
                    body: i == 0
                        ? 'push_text_1'.tr
                        : 'push_text_2'.tr + '$i' + 'push_text_3'.tr, //需要国际化
                    // notificationLayout: NotificationLayout.BigPicture,
                    // bigPicture: 'asset://assets/images/delivery.jpeg',
                    // payload: {'uuid': 'uuid-test'},
                    // autoCancel: false,
                  ),
                  schedule: NotificationCalendar.fromDate(date: scheduleTime));
            }
          });
        }

        //创建目标完成的推送通知
        String completedIdString = "${target.id}10000";
        await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: int.parse(completedIdString), //每一个推送的id必须不同，否则后面设置的会覆盖前面的
              channelKey: '${target.soundKey}-notifications',
              title: target.name!,
              body: 'push_text_4'.tr, //需要国际化
              // notificationLayout: NotificationLayout.BigPicture,
              // bigPicture: 'asset://assets/images/delivery.jpeg',
              // payload: {'uuid': 'uuid-test'},
              // autoCancel: false,
            ),
            schedule: NotificationCalendar.fromDate(date: completedTime));
      }
    }
  }

  static Future<void> modifyTargetNotification(Target? target) async {
    if (target != null) {
      //取消当前目标的全部推送
      await cancelTargetNotification(target);

      //重新设置该目标的推送
      await createTargetNotification(target);
    }
  }

  static Future<void> cancelTargetNotification(Target? target) async {
    if (target != null) {
      int targetId = target.id!;

      //获取所有通知
      List<PushNotification> activeSchedules =
          await AwesomeNotifications().listScheduledNotifications();

      //首先取消之前的设置的该目标推送
      activeSchedules.forEach((element) {
        int? id = element.content?.id;
        if (id != null) {
          String idString = id.toString();
          if (idString.startsWith('$targetId')) {
            AwesomeNotifications().cancel(id);
          }
        }
      });
    }
  }
}
