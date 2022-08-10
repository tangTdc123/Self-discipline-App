
import 'package:quit_product/common/config.dart';
import 'package:quit_product/core/database/providers/note_table_provider.dart';
import 'package:quit_product/core/database/providers/target_table_provider.dart';
import 'package:quit_product/manager/notification_manager.dart';
import 'package:quit_product/models/jounery.dart';
import 'package:quit_product/models/note.dart';
import 'package:quit_product/models/target.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quit_product/pages/target/target_edit.dart';
import 'package:quit_product/routes/app_routes.dart';
import 'package:quit_product/utils/object_util.dart';


class TargetDetailController extends GetxController {
  late Target target;

  List<Jounery> jouneries = [];

  NoteTableProvider noteTableProvider = NoteTableProvider();

  TargetTableProvider targetTableProvider = TargetTableProvider();

  @override
  void onInit() {
    super.onInit();
    Target targetArgument = Get.arguments;

    //进入详情页，必须更新目标状态，因为需要实时查询目标状态
    target = Target.generateTargetCurrentStatus(targetArgument);

    // update(['appbar']);

    //     Target starget = Get.arguments;
    // target = starget.obs;
    // print(target.name);

    //判断目前的状态

    queryNotes();

    //查询心声notes，并拼接成jouneries历程，显示

    // DateTime nowTime = DateTime.now();
    // print(nowTime);
    // print(nowTime
    //     .toIso8601String()); //2020-06-22T17:52:17.108937 输出格式ISO8601标准时间格式
    // print(nowTime
    //     .toUtc()
    //     .toString()); //2020-06-22 09:53:26.373952Z 输出时间为UTC时间，注意的是中间不带T，以Z结尾，用以区分是否是UTC时间
    // print(nowTime
    //     .toString()); //2020-06-22 09:53:26.373952 输出当前当地时间(不绝对)，与UTC时间的区别是不带后面的Z
    // print(nowTime.toLocal().toString()); //输出当前当地时间

    // DateTime time = DateTime.parse("2020-06-22 09:53:26");
    // print(time);
    // print(time.toString());
    // print(time.toUtc().toString());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void queryNotes() async {
    List<Map<String, dynamic>>? queryedNotes;
    try {
      queryedNotes = await noteTableProvider.queryNotes(targetId: target.id!);
    } catch (e) {
      print(e);
    }

    jouneries.add(Jounery()
      ..text = 'challenge_begin'.tr
      ..createTime = target.createTime);

    if (!ObjectUtil.isEmptyList(queryedNotes)) {
      List notes = [];
      queryedNotes!.forEach((element) {
        if (!ObjectUtil.isEmptyMap(element)) {
          Note? note = Note.noteFromMap(element);
          if (note != null) {
            notes.add(note);
          }
        }
      });

      if (notes.length > 0) {
        notes.forEach((element) {
          jouneries.add(Jounery()
            ..text = element.note
            ..createTime = element.createTime);
        });
      }
    }

    if (target.targetStatus == TargetStatus.completed) {
      jouneries.add(Jounery()
        ..text = 'challenge_completed'.tr
        ..createTime =
            target.createTime!.add(Duration(days: target.targetDays!)));
    } else if (target.targetStatus == TargetStatus.giveuped) {
      jouneries.add(Jounery()
        ..text = 'challenge_giveup'.tr
        ..createTime = target.giveUpTime);
    }

    update(['all']);
  }

  void saveNote(String noteText) {
    print("-----");

    //保存日志之前，首先得判断当前目标的状态，因为用户可能停留在这个页面很久了，目标可能已经结束了。结束了就不让再输入日志了
    target = Target.generateTargetCurrentStatus(target);
    if (target.targetStatus != TargetStatus.processing) {
      //如果目标已经不是进行中，则更新目标对象和页面
      updateTarget(target);
    } else {
      Note note = Note()
        ..targetId = target.id
        ..note = noteText
        ..createTime = DateTime.now();

      //插入数据库
      noteTableProvider.insertNote(note).then((value) {
        //插入成功，再次查询数据库，刷新页面
        jouneries.clear();
        queryNotes();
      }).catchError((error) {
        print("插入note失败");
      });
    }
  }

  //编辑目标后，更新当前详情页目标对象
  void updateTarget(Target updateTarget) {
    target = updateTarget;

    update(['all', 'appbar']);
  }

  //跳转编辑页面
  void editTarget(BuildContext context) {
    //首先得判断当前目标的状态，因为用户可能停留在这个页面很久了，目标可能已经结束了。就不能编辑了
    target = Target.generateTargetCurrentStatus(target);

    if (target.targetStatus != TargetStatus.processing) {
      //如果目标已经不是进行中，则更新目标对象和页面
      updateTarget(target);
    } else {
      //跳转编辑页面
      CupertinoScaffold.showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => TargetEditPage(
                target,
                enterType: TaskEditPageEnterType.TaskEditPageEnterType_Edit
,
              ),
          enableDrag: true,
          expand: true,
          backgroundColor: Colors.transparent);
    }
  }

  void giveUpTarget() async {
    //点击放弃按钮时，先判断当前target的状态（用户可能一直停在详情页，用户点击放弃按钮的时候，目标可能已经完成了），实时的 TODO
    target = Target.generateTargetCurrentStatus(target);

    if (target.targetStatus != TargetStatus.processing) {
      //如果目标已经不是进行中，则更新目标对象和页面
      updateTarget(target);
    } else {
      //弹出对话框，引导用户不要放弃，去做一些运动
      showDialog(
          context: Get.context!,
          builder: (ctx) {
            return WillPopScope(
                onWillPop: () async {
                  return true;
                },
                child: Material(
                    type: MaterialType.transparency,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // GestureDetector(
                        //     onTap: () {
                        //       Navigator.of(context).pop();
                        //     },
                        //     child: Container(
                        //       color: Colors.transparent,
                        //     )),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(left: 40, right: 40),
                            width: double.infinity,
                            // height: 260,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 20, left: 20, right: 20),
                                  child: RichText(
                                      text: TextSpan(
                                          text:
                                              '${'give_up_promote'.tr}  ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: textBlackColor,
                                              fontWeight: FontWeight.w400),
                                          children: [
                                        TextSpan(
                                          text: 'try_exercise'.tr,
                                          style: TextStyle(
                                            color: target.targetColor!,
                                            // decoration:
                                            //     TextDecoration.underline,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.of(Get.context!).pop();
                                              //跳转运动页面
                                              Get.toNamed(Routes.EXERCISE,
                                                  arguments: {
                                                    "from": "DetailPage"
                                                  });
                                            },
                                        )
                                      ])),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  height: 50,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(Get.context!).pop();
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
                                                          239, 240, 241, 1)))),
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
                                          target = Target
                                              .generateTargetCurrentStatus(
                                                  target);
                                          if (target.targetStatus !=
                                              TargetStatus.processing) {
                                            Navigator.of(Get.context!).pop();
                                            updateTarget(target);
                                          } else {
                                            //执行放弃操作
                                            //更新数据库，更新首页，更新当前详情页
                                            //取消该目标的所有推送

                                            targetTableProvider
                                                .giveupTarget(target)
                                                .then((value) {
                                              Navigator.of(Get.context!).pop();

                                              //取消该目标的所有推送
                                              NotificationManager.cancelTargetNotification(target);

                                              target.targetStatus =
                                                  TargetStatus.giveuped;
                                              jouneries.add(Jounery()
                                                ..text = 'challenge_giveup'.tr
                                                ..createTime = DateTime.now());

                                              update(['all', 'appbar']);
                                            }).catchError((error) {
                                              print(error);
                                            });
                                          }
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      width: 1.0,
                                                      color: Color.fromRGBO(
                                                          239, 240, 241, 1)))),
                                          child: Center(
                                            child: Text('giveup'.tr,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        220, 220, 220, 1),
                                                    fontSize: 12)),
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )));
          });
    }

    // //更新数据库，更新首页，更新当前详情页
    // targetTableProvider.giveupTarget(target).then((value) {
    //   target.targetStatus = TargetStatus.giveuped;
    //   jouneries.add(Jounery()
    //     ..text = "放弃挑战"
    //     ..createTime = DateTime.now());

    //   update(['all', 'appbar']);
    // }).catchError((error) {
    //   print(error);
    // });
  }
}
