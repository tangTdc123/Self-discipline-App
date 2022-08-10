import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quit_product/common/config.dart';
import 'package:quit_product/common/widgets/common_widget.dart';
import 'package:quit_product/common/widgets/custom_dialog.dart';
import 'package:quit_product/core/database/providers/target_table_provider.dart';
import 'package:quit_product/models/sound.dart';
import 'package:quit_product/models/target.dart';
import 'package:quit_product/pages/home/home_controller.dart';
import 'package:quit_product/pages/target/target_controller.dart';
import 'package:quit_product/routes/app_routes.dart';
import 'package:quit_product/utils/date_time.dart';
import 'package:quit_product/utils/object_util.dart';

enum TaskEditPageEnterType {
  TaskEditPageEnterType_new,
  TaskEditPageEnterType_Edit
}

class TargetEditPage extends StatefulWidget {
  final Target target;
  final TaskEditPageEnterType enterType;
  const TargetEditPage(this.target,
      {Key? key,
      this.enterType = TaskEditPageEnterType.TaskEditPageEnterType_new})
      : super(key: key);

  @override
  State<TargetEditPage> createState() => _TargetEditPageState();
}


class _TargetEditPageState extends State<TargetEditPage> {
  int? targetDays;
  TextEditingController textEditingController = TextEditingController()
    ..addListener(() {});
  FocusNode focusNode = FocusNode();

  Color? targetColor;

  String? soundKey;

  List<TimeOfDay>? targetNotificationTimes;

  bool isDeleteMode = false;

  final HomeController homeController = Get.find<HomeController>();

  late TargetController targetDetailController;

  final _notificationTimesMaxLimit = 4;

  @override
  void initState() {
    super.initState();

    print("initState");

    // if (widget.taskEditMode == TaskEditPageEnterType.TaskEditPageEnterType_Edit) {
    //   targetDetailController = Get.find<TargetDetailController>();
    // }

    targetDays = widget.target.targetDays;
    targetColor = widget.target.targetColor;

    if (ObjectUtil.isEmptyString(widget.target.soundKey)) {
      //新增时soundKey为null, 默认为第一个
      soundKey = notificationSounds[0].soundKey;
    } else {
      soundKey = widget.target.soundKey;
    }

    targetNotificationTimes = List.from(widget.target.notificationTimes ?? []);

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          targetDays = null;
        });
      } else {}
    });
  }

  String _renderDisplaySoundName() { 
    String displaySoundName = '';
    for (int i = 0; i < notificationSounds.length; i++) {
      Sound sound = notificationSounds[i];
      if (sound.soundKey == soundKey) {
        displaySoundName = sound.soundName;
        break;
      }
    }

    return displaySoundName;
  }


  
  void _save() async {
    if (widget.enterType == TaskEditPageEnterType.TaskEditPageEnterType_Edit) {
      //编辑目标，更新数据库
      Target updateTarget = Target()
        ..id = widget.target.id
        ..name = widget.target.name
        ..targetDays = targetDays
        ..targetColor = targetColor
        ..soundKey = soundKey
        ..createTime = widget.target.createTime
        ..targetStatus = widget.target.targetStatus
        ..giveUpTime = widget.target.giveUpTime
        ..notificationTimes = List.from(targetNotificationTimes ?? []);

      //首先判断目标当前状态，如果不是在进行中，就不能编辑了，因为可能用户在这个页面停留了很长时间
      updateTarget = Target.generateTargetCurrentStatus(updateTarget);

      if (updateTarget.targetStatus != TargetStatus.processing) {
        //如果目标已经不是进行中，则销毁当前页面，并刷新目标详情页
        targetDetailController.updateTarget(updateTarget);

        Navigator.of(context).pop();
      } else {
        TargetTableProvider targetTableProvider = TargetTableProvider();
        targetTableProvider.updateTarget(updateTarget).then((value) {
          //刷新首页和详情页
          targetDetailController.updateTarget(updateTarget);

          // Navigator.of(context).replace(oldRoute: GetPageRoute(routeName: Routes.TARGETDETAIL), newRoute: ModalRoute.withName(""));

          // Get.o

          homeController.refreshTargets();

          // //更新推送时间
          // NotificationManager.modifyTargetNotification(updateTarget);

          Navigator.of(context).pop();
        }).catchError((error) {
          print(error);
        });
      }
    } else if (widget.enterType == TaskEditPageEnterType.TaskEditPageEnterType_new) {
      //新增目标
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }

      TargetTableProvider targetTableProvider = TargetTableProvider();

      //不能重复创建目标(进行中的)，用目标名来判别是不是同一个目标
      List<Target> targets =
          await targetTableProvider.queryTargetsByName(widget.target.name!);

      bool hasProcessingTarget = false;

      if (!ObjectUtil.isEmptyList(targets)) {
        //再筛选出其中已经完成的
        for (int i = 0; i < targets.length; i++) {
          Target target = targets[i];

          DateTime completedTime =
              target.createTime!.add(Duration(days: target.targetDays!));

          if (DateTime.now().isBefore(completedTime)) {
            //进行中
            hasProcessingTarget = true;
            break;
          }
        }
      }

      if (hasProcessingTarget == true) {
        showCustomToast('target is ongoing'.tr);
        Navigator.of(context).pop();

        return;
      }

      if (targetDays == null) {
        showCustomToast('set days'.tr);
        return;
      }

      // 存入本地数据库
      print(targetDays);
      print(targetColor);
      print(targetNotificationTimes);

      Target saveTarget = Target()
        ..name = widget.target.name
        ..targetDays = targetDays
        ..targetColor = targetColor
        ..soundKey = soundKey
        ..notificationTimes = List.from(targetNotificationTimes ?? []);

      //保存到本地数据库
      // int ids = await targetTableProvider.insertTarget(saveTarget);
      //       print("-------value = $ids---------");

      targetTableProvider.insertTarget(saveTarget).then((value) {
        print("-------value = $value---------");

        saveTarget.id = value['rowid'];
        saveTarget.createTime = value['createTime'];
        //创建本地通知
        // NotificationManager.createTargetNotification(saveTarget);

        //刷新首页任务列表
        homeController.refreshTargets();

        Get.until((route) {
          if (route.settings.name == Routes.HOME) {
            return true;
          }
          return false;
        });
      }).catchError((error) {
        print(error);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
            color: Colors.transparent,
            child: Scaffold(
                backgroundColor: Colors.white.withOpacity(0.95),
                body: SafeArea(
                    child: GestureDetector(
                        onTap: () {
                          //隐藏键盘
                          FocusScope.of(context).requestFocus(new FocusNode());

                          if (isDeleteMode == true) {
                            setState(() {
                              isDeleteMode = false;
                            });
                          }
                        },
                        child: Container(
                            // color: CupertinoTheme.of(context)
                            //     .scaffoldBackgroundColor
                            //     .withOpacity(0.1),
                            // color: Colors.white.withOpacity(0.1),
                            child: Stack(
                          children: [
                            Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                child: Container(
                                    height: 60,
                                    color: Colors.transparent,
                                    child: Stack(children: [
                                      Container(
                                          alignment: Alignment.center,
                                          child: Text(widget.target.name!,
                                              style: TextStyle(
                                                  color: targetColor,
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                      Positioned(
                                          top: 17.5,
                                          left: 20,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: targetColor),
                                              width: 50,
                                              height: 25,
                                              alignment: Alignment.center,
                                              child: Text('cancel'.tr,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14)),
                                            ),
                                          )),
                                      Positioned(
                                          top: 17.5,
                                          right: 20,
                                          child: InkWell(
                                            onTap: () {
                                              _save();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: targetColor),
                                              width: 50,
                                              height: 25,
                                              alignment: Alignment.center,
                                              child: Text('save'.tr,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14)),
                                            ),
                                          ))
                                    ]))),
                            Positioned(
                                left: 0,
                                right: 0,
                                top: 60,
                                bottom: 0,
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(bottom: 40),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              padding: EdgeInsets.only(
                                                  left: 0.0, right: 0),
                                              // color: Colors.orange,
                                              // decoration: BoxDecoration(
                                              //     color:
                                              //         Color.fromRGBO(240, 240, 240, 1),
                                              //     borderRadius: BorderRadius.all(
                                              //         Radius.circular(26.0))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Offstage(
                                                      offstage: widget
                                                              .enterType ==
                                                          TaskEditPageEnterType
                                                              .TaskEditPageEnterType_Edit,
                                                      child: Container(
                                                          height: 60.0,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              'select_day'.tr,
                                                              style: TextStyle(
                                                                color:
                                                                    textBlackColor,
                                                                fontSize: 18.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              )))),
                                                  // Container(
                                                  //   height: 0.5,
                                                  //   color: Color.fromRGBO(250, 250, 250, 1),
                                                  // ),
                                                  Offstage(
                                                      offstage: widget
                                                              .enterType ==
                                                          TaskEditPageEnterType
                                                              .TaskEditPageEnterType_Edit,
                                                      child: Container(
                                                          width:
                                                              double.infinity,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10.0,
                                                                  right: 0.0),
                                                          // color: Colors.red,
                                                          child:
                                                              _renderTargetDays())),
                                                  Offstage(
                                                      offstage: widget
                                                              .enterType ==
                                                          TaskEditPageEnterType
                                                              .TaskEditPageEnterType_Edit,
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10.0,
                                                            right: 10.0,
                                                            top: 15.0,
                                                            bottom: 15.0),
                                                        child: Text(
                                                            "${'custom_days'.tr} <= 100${'days'.tr}",
                                                            style: TextStyle(
                                                              color:
                                                                  textBlackColor,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            )),
                                                      )),
                                                  Offstage(
                                                      offstage: widget
                                                              .enterType ==
                                                          TaskEditPageEnterType
                                                              .TaskEditPageEnterType_Edit,
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10.0,
                                                            right: 10.0),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                                width: 80,
                                                                height: 35,
                                                                decoration: BoxDecoration(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            240,
                                                                            240,
                                                                            240,
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            10.0))),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: TextField(
                                                                    focusNode: focusNode,
                                                                    inputFormatters: [
                                                                      // FilteringTextInputFormatter(
                                                                      //     _inputReg(),
                                                                      //     allow:
                                                                      //         true)
                                                                      // LengthLimitingTextInputFormatter(3)
                                                                      InputDaysFormatter()
                                                                    ],
                                                                    onChanged: (String str) {
                                                                      print(textEditingController
                                                                          .text);
                                                                      print(
                                                                          str);

                                                                      targetDays = ObjectUtil.isEmptyString(
                                                                              str)
                                                                          ? null
                                                                          : int.parse(
                                                                              str);
                                                                    },
                                                                    controller: textEditingController,
                                                                    textAlign: TextAlign.center,
                                                                    textAlignVertical: TextAlignVertical.center,
                                                                    cursorColor: targetColor,
                                                                    keyboardType: TextInputType.number,
                                                                    style: TextStyle(
                                                                      color:
                                                                          targetColor,
                                                                      fontSize:
                                                                          20.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                    decoration: InputDecoration(
                                                                      // border:
                                                                      //     InputBorder
                                                                      //         .none,

                                                                      contentPadding: EdgeInsets.only(
                                                                          left:
                                                                              15,
                                                                          right:
                                                                              15),
                                                                      border: OutlineInputBorder(

                                                                          ///设置边框四个角的弧度
                                                                          // borderRadius: BorderRadius.all(Radius.circular(0)),

                                                                          ///用来配置边框的样式
                                                                          borderSide: BorderSide.none),
                                                                      // hintText: "请输入邮箱",
                                                                      // hintStyle: TextStyle(color: Colors.black, fontSize: 10)
                                                                    ))),
                                                            SizedBox(width: 10),
                                                            Text('days'.tr,
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      textBlackColor,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ))
                                                          ],
                                                        ),
                                                      )),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 30),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            height: 60,
                                                            // color: Colors.orange,
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                'select_color'
                                                                    .tr,
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      textBlackColor,
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ))),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 20),
                                                          child: _renderColorSelectWidget(
                                                              colorSelectCallBack:
                                                                  (color) {
                                                            print(color);
                                                            setState(() {
                                                              targetColor =
                                                                  color;
                                                            });
                                                          }),
                                                        ),
                                                        Container(
                                                              height: 60,
                                                              // color: Colors.orange,
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  'notify_sound'
                                                                      .tr,
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        textBlackColor,
                                                                    fontSize:
                                                                        18.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ))), 
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    right: 40),
                                                            child: Container(
                                                              height: 45,
                                                              decoration: BoxDecoration(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          240,
                                                                          240,
                                                                          240,
                                                                          1),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10.0))),
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  showModalBottomSheet(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      context:
                                                                          context,
                                                                      isScrollControlled:
                                                                          true, 
                                                                          enableDrag: false,//必须设置这个，否则高度不能控制
                                                                      builder:
                                                                          (ctx) {
                                                                        return SoundSelectWidget(
                                                                            soundKey:
                                                                                soundKey,
                                                                            baseColor:
                                                                                targetColor,
                                                                            selectSoundCallBack:
                                                                                (sound) {
                                                                              setState(() {
                                                                                soundKey = sound.soundKey;
                                                                              });
                                                                            });
                                                                      });
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                        //圆角
                                                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0)))),
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              15,
                                                                          right:
                                                                              10),
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: SvgPicture.asset(
                                                                          'assets/icons/common/sound.svg',
                                                                          color:
                                                                              targetColor,
                                                                          width:
                                                                              28,
                                                                          height:
                                                                              28),
                                                                    ),
                                                                    Text(
                                                                        _renderDisplaySoundName(),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              targetColor,
                                                                          fontSize:
                                                                              18.0,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ))
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 30),
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                        height:
                                                                            60,
                                                                        // color: Colors
                                                                        //     .orange,
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        child: Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Text('notify_time'.tr,
                                                                                  style: TextStyle(
                                                                                    color: textBlackColor,
                                                                                    fontSize: 18.0,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  )),
                                                                              !ObjectUtil.isEmptyList(targetNotificationTimes)
                                                                                  ? InkWell(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          isDeleteMode = !isDeleteMode;
                                                                                        });
                                                                                      },
                                                                                      child: Container(
                                                                                        margin: EdgeInsets.only(left: 8, top:4),
                                                                                        width: 30,
                                                                                        height: 30,
                                                                                        alignment: Alignment.center,
                                                                                        child: SvgPicture.asset('assets/icons/common/minus.svg', color: targetColor, width: 25, height: 25),
                                                                                      ),
                                                                                    )
                                                                                  : SizedBox.shrink(),
                                                                              (ObjectUtil.isEmptyList(targetNotificationTimes) || targetNotificationTimes!.length < _notificationTimesMaxLimit)
                                                                                  ? InkWell(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          isDeleteMode = (isDeleteMode ? false : isDeleteMode);
                                                                                        });

                                                                                        //新增时间
                                                                                        showNotificationTimePickerDialog(context, selectTimeCallBack: (selectedHour, selectedMins) {
                                                                                          if (selectedHour != null && selectedMins != null) {
                                                                                            print(selectedHour + "|||||||||||||" + selectedMins);
                                                                                            TimeOfDay addedTimeOfDay = TimeOfDay(hour: int.parse(selectedHour), minute: int.parse(selectedMins));
                                                                                            if (!targetNotificationTimes!.contains(addedTimeOfDay)) {
                                                                                              setState(() {
                                                                                                targetNotificationTimes!.add(addedTimeOfDay);
                                                                                                targetNotificationTimes!.sort((e1, e2) {
                                                                                                  return (e1.hour.compareTo(e2.hour) == 0 ? e1.minute.compareTo(e2.minute) : e1.hour.compareTo(e2.hour));
                                                                                                });
                                                                                              });
                                                                                            }
                                                                                          }
                                                                                        }, bgColor: targetColor);
                                                                                      },
                                                                                      child: Container(width: 30, height: 30, margin: EdgeInsets.only(left: 5, top:4), alignment: Alignment.center, child: SvgPicture.asset('assets/icons/common/plus.svg', color: targetColor, width: 25, height: 25)),
                                                                                    )
                                                                                  : SizedBox.shrink()
                                                                            ])),
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                0),
                                                                        child: _renderTimeNotificationWidget(
                                                                            isDeleteMode,
                                                                            deleteCallBack:
                                                                                (index) {
                                                                          //删除时间
                                                                          print(
                                                                              index);

                                                                          setState(
                                                                              () {
                                                                            targetNotificationTimes!.removeAt(index);
                                                                          });
                                                                        }))
                                                                  ]))
                                                        
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                )))
                          ],
                        )))))));
  }
Widget _renderTimeNotificationWidget(bool isDeleteMode,
      {Function(int index)? deleteCallBack}) {
    if (ObjectUtil.isEmptyList(targetNotificationTimes))
      return SizedBox.shrink();

    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 16.0,
      runAlignment: WrapAlignment.start,
      runSpacing: 16.0,
      children: targetNotificationTimes!.asMap().keys.map((index) {
        TimeOfDay timeOfDay = targetNotificationTimes![index];
        return TimeNotificationWidget(timeOfDay,
            isDeleteMode: isDeleteMode,
            bgColor: targetColor, deleteCallBack: () {
          deleteCallBack?.call(index);
        });
      }).toList(),
    );
  }

  Widget _renderColorSelectWidget(
      {Function(Color color)? colorSelectCallBack}) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 16.0,
      runAlignment: WrapAlignment.start,
      runSpacing: 16.0,
      children: colors
          .map((color) => InkWell(
              onTap: () {
                colorSelectCallBack?.call(color);
              },
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                    color: color,
                    border: color == targetColor
                        ? Border.all(width: 3.5, color: textBlackColor)
                        : null,
                    borderRadius: BorderRadius.all(Radius.circular(13))),
              )))
          .toList(),
    );
  }

  Widget _renderTargetDays() {
    return Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        spacing: 16.0,
        runAlignment: WrapAlignment.start,
        runSpacing: 16.0,
        children: defaultTargetDays
            .map(
              (e) => InkWell(
                  onTap: () {
                    setState(() {
                      targetDays = e;
                    });

                    if (focusNode.hasFocus) {
                      focusNode.unfocus();
                    }

                    textEditingController.text = "";
                  },
                  child: Container(
                      width: 90,
                      height: 35,
                      decoration: BoxDecoration(
                          color: targetDays == e
                              ? targetColor
                              : Color.fromRGBO(240, 240, 240, 1),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      alignment: Alignment.center,
                      child: Text(e.toString(),
                          style: TextStyle(
                              color: targetDays == e
                                  ? Colors.white
                                  : textBlackColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400)))),
            )
            .toList());
  }
}

class TimeNotificationWidget extends StatelessWidget {
  TimeNotificationWidget(this.timeOfDay,
      {this.isDeleteMode = false, this.bgColor, this.deleteCallBack});

  final TimeOfDay timeOfDay;
  final bool isDeleteMode;
  final Function? deleteCallBack;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 90,
        height: 35,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Stack(children: [
          Container(
              alignment: Alignment.center,
              child: Text(timeOfDayConvertToString(timeOfDay) ?? "",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400))),
          isDeleteMode
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                      onTap: () {
                        //删除这一条时间
                        this.deleteCallBack?.call();
                      },
                      child: Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.topRight,
                          decoration: BoxDecoration(
                              // color: Colors.orange,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.0))),
                          child: SvgPicture.asset(
                            'assets/icons/common/minus.svg',
                            width: 20,
                            height: 20,
                            color: Colors.white,
                          ))))
              : SizedBox.shrink()
        ]));
  }
}

class InputDaysFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // print("oldvalue = " + oldValue.text);
    // print("newValue = " + newValue.text);

    if (oldValue.text.length <= 0 && newValue.text == "0") {
      return oldValue;
    }

    if (newValue.text == "") {
      return newValue;
    }

    if (int.parse(newValue.text) > 100) {
      return oldValue;
    }

    return newValue;
  }
}
class SoundSelectWidget extends StatefulWidget {
  SoundSelectWidget(
      {this.soundKey, this.baseColor = Colors.green, this.selectSoundCallBack});
  final String? soundKey;
  final Color? baseColor;
  final Function(Sound selectedSound)? selectSoundCallBack;

  @override
  State<StatefulWidget> createState() {
    return SoundSelectWidgetState();
  }
}

class SoundSelectWidgetState extends State<SoundSelectWidget> {
  List<Sound> sounds = List.from(notificationSounds);

  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache =AudioCache();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    audioCache = AudioCache(prefix: '');

          audioCache.fixedPlayer = audioPlayer;
    if (!ObjectUtil.isEmptyString(widget.soundKey)) {
      for (int i = 0; i < sounds.length; i++) {
        Sound sound = sounds[i];
        if (sound.soundKey == widget.soundKey) {
          _selectedIndex = i;
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
    
    
  }

  Widget _renderSoundView(int selectedIndex,
      {required Function(int index) callBack,
      required Function(Sound sound) selectSoundCallBack}) {
    List<Widget> widgets = [];

    widgets.add(Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      // height: 25,
      width: double.infinity,
      child: Text('select_sound'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textBlackColor,
              fontSize: 22,
              fontWeight: FontWeight.w600)),
    ));

    for (int i = 0; i < sounds.length; i++) {
      Sound sound = sounds[i];
      widgets.add(GestureDetector(
        onTap: () async {
          // audioPlayer!.stop();
          callBack(i);

          if (audioPlayer != null) {
            print('1');
            
            audioPlayer.stop();
          }
          
          audioCache.play(sound.soundPath);
          

        },
        child: Container(
          margin: EdgeInsets.only(left: 60, right: 60, top: 5, bottom: 5),
          height: 50,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: selectedIndex == i
                  ? widget.baseColor!.withOpacity(0.2)
                  : Colors.white,
              borderRadius: selectedIndex == i
                  ? BorderRadius.all(Radius.circular(10))
                  : null),
          child: Text(sound.soundName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textBlackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400)),
        ),
      ));
    }

    widgets.add(GestureDetector(
        onTap: () {
          selectSoundCallBack(sounds[_selectedIndex]);
        },
        child: Container(
          margin: EdgeInsets.only(top: 20, bottom: 20, left: 90, right: 90),
          height: 45,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: widget.baseColor!,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text('confirm'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400)),
        )));

    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 400,
      color: Colors.transparent,
      // alignment: Alignment.bottomCenter,
      child: Stack(fit: StackFit.expand, children: [
        GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Container(
      color: Colors.transparent,
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                // height: 400,
                // margin: EdgeInsets.only(
                //     left: 15,
                //     right: 15,
                //     bottom: MediaQuery.of(context).padding.bottom + 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                    color: Colors.white),
                child: Container(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 10.0),
                  child: _renderSoundView(_selectedIndex, callBack: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }, selectSoundCallBack: (sound) {
                  Navigator.of(context).pop();
                  widget.selectSoundCallBack?.call(sound);
                }))))
      ]),
    );
  }
}
