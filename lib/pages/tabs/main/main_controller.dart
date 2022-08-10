import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quit_product/common/config.dart';
import 'package:quit_product/core/database/providers/target_table_provider.dart';
import 'package:quit_product/manager/shared_preference_manager.dart';
import 'package:quit_product/models/exercise.dart';
import 'package:quit_product/models/target.dart';
import 'package:quit_product/pages/home/home_controller.dart';
import 'package:quit_product/routes/app_routes.dart';
import 'package:quit_product/utils/object_util.dart';
import 'package:sqflite/sqflite.dart';
class MainController extends GetxController with WidgetsBindingObserver {
  //页面显示的目标数组
  List<Target> savedTargets = [];

  TargetTableProvider targetTableProvider = TargetTableProvider();

  late HomeController homeController;

  FilterType currentFilterType = FilterType.all;

  //下拉刷新
  RefreshController refreshController = RefreshController();

  //上方3张运动图，随机3张
  List<Exercise> exerciseLotties = [];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance!.addObserver(this);
    print("~~~~~~~~~~~~~~~~MainController onInit~~~~~~~~~~~~~~~~");

    this.generateExercisesLotties();

    this.querySavedTargets(currentFilterType);
  }

  @override
  void onReady() async {
    super.onReady();

    print("~~~~~~~~~~~~~~~~MainController onReady~~~~~~~~~~~~~~~~");

    //获取系统通知权限

    //flutter-permission-handler这个插件没有返回iOS的not notDetermined状态
    // PermissionStatus status = await Permission.notification.status;
    // print(status);

    // if (status != PermissionStatus.granted) {
    //   PermissionStatus status = await Permission.notification.request();
    //   print(status);
    // }

    //展示隐私政策
    //首先读取该版本是否已经同意
    bool needShowPolicyDialog =
        await SharedPreferenceManager.userHasAgreePolicy();
    if (needShowPolicyDialog == false) {
      showDialog(
          context: Get.overlayContext!,
          barrierDismissible: false,
          builder: (context) {
            return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Material(
                    type: MaterialType.transparency,
                    child: Align(
                        alignment: Alignment.center,
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            padding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 30, right: 20),
                            // width: 280,
                            height: 340,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: Text('policy'.tr,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: textBlackColor,
                                          fontWeight: FontWeight.w500,
                                        ))),
                                Expanded(
                                    child: Scrollbar(
                                        // thickness: 6.w,
                                        // radius: Radius.circular(3.w),
                                        isAlwaysShown: true,
                                        // controller: scrollController,
                                        child: SingleChildScrollView(
                                          physics: BouncingScrollPhysics(),
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          // controller: scrollController,
                                          child: Container(
                                              width: double.infinity,
                                              margin:
                                                  EdgeInsets.only(right: 12),
                                              // color: Colors.orange,
                                              child: Text('policy_text'.tr,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: textBlackColor,
                                                    fontWeight: FontWeight.w400,
                                                  ))),
                                        ))),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  // color: Colors.blue,
                                  height: 36,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            exit(0);
                                          },
                                          child: Container(
                                              width: 90,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      242, 243, 244, 1),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              alignment: Alignment.center,
                                              child: Text('quit'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: textGreyColor,
                                                    fontWeight: FontWeight.w400,
                                                  )))),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();

                                            SharedPreferenceManager
                                                .saveUserPolicyCache();

                                            //初始化友盟统计
                                            // UmengCommonSdk.initCommon(
                                            //     Platform.isIOS
                                            //         ? '619351b3e014255fcb7beaf2'
                                            //         : '61937081e014255fcb7c6909',
                                            //     Platform.isIOS
                                            //         ? '619351b3e014255fcb7beaf2'
                                            //         : '61937081e014255fcb7c6909',
                                            //     Platform.isIOS
                                            //         ? "App Store"
                                            //         : "Google Play");
                                          },
                                          child: Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: commonGreenColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              alignment: Alignment.center,
                                              child: Text('agree'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ))))
                                    ],
                                  ),
                                )
                              ],
                            )))));
          });
    } else {
      //已经同意
      //初始化友盟统计
      // UmengCommonSdk.initCommon(
      //     Platform.isIOS
      //         ? '619351b3e014255fcb7beaf2'
      //         : '61937081e014255fcb7c6909',
      //     Platform.isIOS
      //         ? '619351b3e014255fcb7beaf2'
      //         : '61937081e014255fcb7c6909',
      //     Platform.isIOS ? "App Store" : "Google Play");
    }

    Future.delayed(Duration(seconds: 2), () async {
      PermissionStatus status = await Permission.notification.request();
      if (status != PermissionStatus.granted) {
        // Future.delayed(Duration(seconds: 1), () {
        int random = Random().nextInt(3);
        print("-----$random-------");
        if (random == 0) {
          showDialog(
              context: Get.overlayContext!,
              barrierDismissible: false,
              builder: (context) {
                return WillPopScope(
                    child: Material(
                      type: MaterialType.transparency,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                            margin:
                                EdgeInsets.only(top: 200, left: 40, right: 40),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    width: double.infinity,
                                    child: Text('notification setting'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: textBlackColor,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 15, left: 30, right: 30),
                                    child: Text('notification permission'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: textBlackColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 30),
                                    height: 50,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    top: BorderSide(
                                                        width: 1.0,
                                                        color: Color.fromRGBO(
                                                            239, 240, 241, 1)),
                                                    right: BorderSide(
                                                        width: 1.0,
                                                        color: Color.fromRGBO(
                                                            239,
                                                            240,
                                                            241,
                                                            1)))),
                                            child: Center(
                                              child: Text('cancel'.tr,
                                                  style: TextStyle(
                                                      color: textBlackColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                        )),
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            Future.delayed(
                                                Duration(milliseconds: 300),
                                                () {
                                              openAppSettings();
                                            });
                                          },
                                          child: Container(
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    top: BorderSide(
                                                        width: 1.0,
                                                        color: Color.fromRGBO(
                                                            239,
                                                            240,
                                                            241,
                                                            1)))),
                                            child: Center(
                                              child: Text('go to'.tr,
                                                  style: TextStyle(
                                                      color: textBlackColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                        ))
                                      ],
                                    ),
                                  )
                                ])),
                      ),
                    ),
                    onWillPop: () async {
                      return false;
                    });
              });
        }
      }
    });

    // bool notificationsAllowed =
    //     await AwesomeNotifications().isNotificationAllowed();

    // if (!notificationsAllowed) {
    //   //没有通知权限分为两种情况：1，用户第一次使用，还没有决定 2，用户之前选择了不允许
    //   //如果第一次，会弹出系统通知权限框
    //   await AwesomeNotifications().requestPermissionToSendNotifications();
    // }
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('state = $state');

    if (state == AppLifecycleState.resumed) {
      //刷新列表
      querySavedTargets(currentFilterType);
    }
  }

  void generateExercisesLotties() async {
    List<Exercise> exerciseList = List.from(exercises);

    List<int> indexes = [];

    while (indexes.length != 3) {
      int random = Random().nextInt(exerciseList.length);

      if (!indexes.contains(random)) {
        indexes.add(random);
      }
    }

    for (int i = 0; i < indexes.length; i++) {
      int index = indexes[i];

      exerciseLotties.add(exerciseList[index]);
    }

    // update();
  }

  Future<void> querySavedTargets(FilterType filterType) async {
    print(await getDatabasesPath());

    savedTargets.clear();

    List<Map<String, dynamic>> queryedTargets =
        await targetTableProvider.queryTargets(filterType: currentFilterType);
    print(queryedTargets);

    if (filterType == FilterType.all || filterType == FilterType.giveup) {
      queryedTargets.forEach((element) {
        if (!ObjectUtil.isEmptyMap(element)) {
          Target? target = Target.targetFromMap(element);
          if (target != null) {
            savedTargets.add(target);
          }
        }
      });
    } else if (filterType == FilterType.processing) {
      //进行中
      queryedTargets.forEach((element) {
        if (!ObjectUtil.isEmptyMap(element)) {
          Target? target = Target.targetFromMap(element);
          if (target != null &&
              target.targetStatus == TargetStatus.processing) {
            savedTargets.add(target);

            // DateTime completedTime =
            //     target.createTime!.add(Duration(days: target.targetDays!));
            // //当前时间<完成时间，表示进行中
            // if (DateTime.now().compareTo(completedTime) < 0) {
            //   savedTargets.add(target);
            // }
          }
        }
      });
    } else if (filterType == FilterType.completed) {
      //已完成
      queryedTargets.forEach((element) {
        if (!ObjectUtil.isEmptyMap(element)) {
          Target? target = Target.targetFromMap(element);
          if (target != null && target.targetStatus == TargetStatus.completed) {
            savedTargets.add(target);

            // DateTime completedTime =
            //     target.createTime!.add(Duration(days: target.targetDays!));
            // //当前时间>=完成时间，表示已完成
            // if (DateTime.now().compareTo(completedTime) >= 0) {
            //   savedTargets.add(target);
            // }
          }
        }
      });
    }

    update();
  }

  void updateData() {
    print("成功");

    // savedTargets.clear();

    querySavedTargets(currentFilterType);
  }

  void pushToTaskDetailPage(Target target) {
    Get.toNamed(Routes.TARGETDETAIL,
        arguments: target.clone(), parameters: {"tag": "${++Tags.tag}"});
    // Navigator.of(Get.context!).pushNamed(Routes.TARGETDETAIL, arguments: target.clone());

    //报错
    // Navigator.of(Get.context!).push(GetPageRoute(settings: RouteSettings(name: Routes.TARGETDETAIL, arguments: target.clone())));
  }

  void switchPageToExercise() {
    HomeController controller = Get.find<HomeController>();
    controller.switchPageToExercise();
  }

  void showFilterView() {
    homeController = Get.find<HomeController>();
    homeController.showFilterView();
  }

  void jumpSelectTargetPage() async {
    HomeController controller = Get.find<HomeController>();
    controller.onPushTargetSettingPageAction();

    // await AwesomeNotifications().createNotification(
    //     content: NotificationContent(
    //   id: 1,
    //   channelKey: 'basic_channel',
    //   title: 'Simple Notification',
    //   body: 'Simple body',
    //   // displayOnBackground: true,
    //   displayOnForeground: true,
    // ));
  }

  //更新筛选条件
  void updateFilterType(FilterType type) {
    if (type == currentFilterType) return;

    currentFilterType = type;

    querySavedTargets(currentFilterType);

    // update();
  }

  String getFilterTitle() {
    String title = "";

    switch (currentFilterType) {
      case FilterType.all:
        title = 'all'.tr;
        break;
      case FilterType.processing:
        title = 'progressing'.tr;
        break;
      case FilterType.completed:
        title = 'completed'.tr;
        break;
      case FilterType.giveup:
        title = 'giveup'.tr;
        break;

      default:
        break;
    }
    return title;
  }

  //下拉刷新
  void refreshList() async {
    // Future.delayed(Duration(seconds: 3), () {
    //   refreshController.refreshCompleted();
    // });

    await querySavedTargets(currentFilterType);
    refreshController.refreshCompleted();
  }
}




class Tags{
  static int tag = 0;
}

enum FilterType { all, processing, completed, giveup }
