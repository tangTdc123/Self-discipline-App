import 'dart:async';

import 'package:quit_product/common/config.dart';
import 'package:quit_product/common/widgets/circular_process_indicator.dart';
import 'package:quit_product/models/jounery.dart';
import 'package:quit_product/models/target.dart';
import 'package:quit_product/pages/common/share_page.dart';
import 'package:quit_product/pages/home/home_controller.dart';
import 'package:quit_product/pages/task_detail/target_detail_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quit_product/utils/date_time.dart';
import 'package:quit_product/utils/object_util.dart';

class TargetDetailPage extends StatelessWidget {
  final TargetDetailController targetDetailController =
      Get.find<TargetDetailController>();

  double _caculateProcess() {
    int total =
        Duration(days: targetDetailController.target.targetDays!).inSeconds;
    int duration = DateTime.now()
        .difference(targetDetailController.target.createTime!)
        .inSeconds;
    return duration / total;
  }

  Widget _renderTopTitleView() {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 20),
      // color: Colors.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(targetDetailController.target.name ?? "",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: targetDetailController.target.targetColor,
                    fontSize: 26.0,
                    fontWeight: FontWeight.w500)),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
                "${'start_at'.tr}" +
                    " " +
                    (formatTime(
                            formatter: formatter_2,
                            time: targetDetailController.target.createTime) ??
                        ""),
                style: TextStyle(
                    color: textGreyColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400)),
          )
        ],
      ),
    );
  }

  Widget _renderCountDownView() {
    return Container(
        width: double.infinity,
        // height: 260,
        padding: EdgeInsets.only(top: 30, bottom: 30),
        margin: EdgeInsets.only(top: 30, left: 20, right: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: targetDetailController.target.targetStatus ==
                TargetStatus.processing
            ? Stack(
                // fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Container(
                      alignment: Alignment.center,
                      child: GradientCircularProgressRoute(
                        process: _caculateProcess(),
                        circulColor: targetDetailController.target.targetColor!,
                      )),
                  Container(
                      alignment: Alignment.center,
                      child: _CountDownView(
                        beginTime: targetDetailController.target.createTime!,
                        targetDays: targetDetailController.target.targetDays!,
                        color: targetDetailController.target.targetColor!,
                      )),
                ],
              )
            : (targetDetailController.target.targetStatus ==
                    TargetStatus.completed
                ? Stack(alignment: Alignment.center, children: [
                    Container(
                        // color: Colors.orange.withOpacity(0.5),
                        child: Lottie.asset(
                            'assets/animations/lf30_editor_d9mlluqg.json',
                            width: 300,
                            height: 300,
                            fit: BoxFit.fill,
                            repeat: false)),
                    Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Container(
                          child: Text('congraulations'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color:
                                      targetDetailController.target.targetColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600)),
                        )),
                    Positioned(
                        right: 20,
                        bottom: 10,
                        child: Text(
                            "Oleg Petrunchak-Fesenko on lottiefiles.com",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: textGreyColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)))
                  ])
                : Container(
                    // color: Colors.orange,
                    // height: 230,
                    child: Stack(alignment: Alignment.bottomCenter, children: [
                    Container(
                        // color: Colors.orange,
                        height: 300,
                        child: Lottie.asset(
                            'assets/animations/76025-failed-location-verification.json',
                            width: 170,
                            height: 170,
                            fit: BoxFit.contain,
                            repeat: false)),
                    Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Container(
                          child: Text('regret'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color:
                                      targetDetailController.target.targetColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600)),
                        )),
                    Positioned(
                        right: 20,
                        bottom: 0,
                        child: Text("Nguyễn Như Lân on lottiefiles.com",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: textGreyColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)))
                  ]))));
  }

  Widget _renderNotesView(BuildContext context, {bool buttonVisible = true}) {
    return Container(
        margin: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 30,
            bottom: targetDetailController.target.targetStatus ==
                    TargetStatus.processing
                ? 0
                : 40),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.only(top: 20, left: 20, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('journey'.tr,
                      style: TextStyle(
                          color: textBlackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  buttonVisible == true
                      ? (targetDetailController.target.targetStatus ==
                              TargetStatus.processing
                          ? InkWell(
                              onTap: () {
                                TextEditingController textEditingController =
                                    TextEditingController();
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    // barrierColor: Colors.black.withOpacity(0.6),
                                    builder: (_) => WillPopScope(
                                        child: Material(
                                            type: MaterialType.transparency,
                                            child: Scaffold(
                                              resizeToAvoidBottomInset: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              body: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          color: Colors
                                                              .transparent,
                                                        )),
                                                    Center(
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 40,
                                                            right: 40),
                                                        width: double.infinity,
                                                        // height: 260,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 20),
                                                              child: Text(
                                                                  'journey'.tr,
                                                                  style: TextStyle(
                                                                      color:
                                                                          textBlackColor,
                                                                      fontSize:
                                                                          24,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700)),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 20,
                                                                      left: 40,
                                                                      right:
                                                                          40),
                                                              width: double
                                                                  .infinity,
                                                              height: 120,
                                                              decoration: BoxDecoration(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          239,
                                                                          240,
                                                                          241,
                                                                          1),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10))),
                                                              child: TextField(
                                                                controller:
                                                                    textEditingController,
                                                                style: TextStyle(
                                                                    color: targetDetailController
                                                                        .target
                                                                        .targetColor!),

                                                                maxLength:
                                                                    200, //设置输入字符最大长度，就会显示计数器
                                                                maxLines: null,
                                                                cursorColor:
                                                                    targetDetailController
                                                                        .target
                                                                        .targetColor!,

                                                                decoration:
                                                                    InputDecoration(
                                                                        hintText:
                                                                            "${'record'.tr} ${targetDetailController.target.name!} ${'journey_lower'.tr}",
                                                                        hintStyle: TextStyle(
                                                                            color:
                                                                                textGreyColor,
                                                                            fontSize:
                                                                                14),
                                                                        border: InputBorder
                                                                            .none,
                                                                        //去除textFiled自带边距，让textfield和外层container贴合
                                                                        isCollapsed:
                                                                            true,
                                                                        counterStyle: TextStyle(
                                                                            color:
                                                                                textGreyColor,
                                                                            fontSize:
                                                                                12),
                                                                        //设置textfiled内边距
                                                                        contentPadding:
                                                                            EdgeInsets.all(10)),
                                                                autofocus: true,
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 20),
                                                              height: 50,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                      child:
                                                                          GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height: double
                                                                          .infinity,
                                                                      decoration: BoxDecoration(
                                                                          border: Border(
                                                                              top: BorderSide(width: 1.0, color: Color.fromRGBO(239, 240, 241, 1)),
                                                                              right: BorderSide(width: 1.0, color: Color.fromRGBO(239, 240, 241, 1)))),
                                                                      child:
                                                                          Center(
                                                                        child: Text(
                                                                            'cancel'
                                                                                .tr,
                                                                            style: TextStyle(
                                                                                color: textGreyColor,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  )),
                                                                  Expanded(
                                                                      child:
                                                                          GestureDetector(
                                                                    onTap: () {
                                                                      print(textEditingController
                                                                          .text);

                                                                      if (ObjectUtil.isEmptyString(
                                                                          textEditingController
                                                                              .text)) {
                                                                        return;
                                                                      }

                                                                      //去除头尾空格
                                                                      String
                                                                          text =
                                                                          textEditingController
                                                                              .text
                                                                              .trim();

                                                                      if (ObjectUtil
                                                                          .isEmptyString(
                                                                              text))
                                                                        return;

                                                                      targetDetailController
                                                                          .saveNote(
                                                                              textEditingController.text);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height: double
                                                                          .infinity,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              border: Border(top: BorderSide(width: 1.0, color: Color.fromRGBO(239, 240, 241, 1)))),
                                                                      child:
                                                                          Center(
                                                                        child: Text(
                                                                            'save'
                                                                                .tr,
                                                                            style: TextStyle(
                                                                                color: targetDetailController.target.targetColor!,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ),
                                                                  ))
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                            )),
                                        onWillPop: () async {
                                          return true;
                                        }));
                              },
                              child: Container(
                                  margin: EdgeInsets.only(left: 8),
                                  // color: Colors.orange,
                                  width: 35,
                                  height: 35,
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    'assets/icons/common/edit_1.svg',
                                    width: 30,
                                    height: 30,
                                    color: targetDetailController
                                        .target.targetColor!,
                                  )),
                            )
                          : Container())
                      : Container()
                ],
              ),
            ),
            _renderJouneries()
            // Container(
            //     child: GetBuilder<TargetDetailController>(
            //         id: 'jounery-list',
            //         tag: Get.parameters["tag"],
            //         builder: (controller) {
            //           return _renderJouneries();
            //         }))
          ],
        ));
  }

  Widget _renderJouneries() {
    if (ObjectUtil.isEmptyList(targetDetailController.jouneries))
      return Container();

    List<Widget> widgets = [];

    for (int i = 0; i < targetDetailController.jouneries.length; i++) {
      Jounery jounery = targetDetailController.jouneries[i];
      widgets.add(_JouneryItemWidget(
          jounery: jounery,
          isFirstItem: i == 0,
          isLastItem: i == targetDetailController.jouneries.length - 1,
          isOnlyOneItem: targetDetailController.jouneries.length == 1,
          baseColor: targetDetailController.target.targetColor!));
    }

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Widget _renderGiveUpView() {
    if (targetDetailController.target.targetStatus == TargetStatus.processing) {
      return Container(
        margin: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 40),
        // color: Colors.orange,
        alignment: Alignment.topRight,
        child: Container(
          // width: 80,
          height: 40,
          // alignment: Alignment.center,
          // padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: TextButton(
            onPressed: () {
              //放弃挑战
              targetDetailController.giveUpTarget();
            },
            style: ButtonStyle(
                //圆角
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)))),
            child: Text(
              'giveup_challenge'.tr,
              style: TextStyle(
                  color: Color.fromRGBO(220, 220, 220, 1), fontSize: 12),
            ),
          ),
        ),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: Builder(
          builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
              // 这里设置导航栏颜色
              value: SystemUiOverlayStyle.dark,
              child: CupertinoPageScaffold(
                  child: Scaffold(
                      backgroundColor: const Color.fromRGBO(244, 245, 246, 1),
                      resizeToAvoidBottomInset: false,
                      appBar: PreferredSize(
                          child: Container(
                              color: const Color.fromRGBO(244, 245, 246, 1),
                              padding: EdgeInsets.fromLTRB(
                                  0, Get.context!.mediaQueryPadding.top, 0, 0),
                              child: Stack(
                                children: [
                                  Positioned(
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text("",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  // color: this.baseColor,
                                                  fontWeight:
                                                      FontWeight.w600)))),
                                  Positioned(
                                      top: 0,
                                      left: 10,
                                      bottom: 0,
                                      child: Container(
                                        width: 55.0,
                                        // color: Colors.orange,
                                        alignment: Alignment.center,
                                        child: TextButton(
                                            onPressed: () {
                                              HomeController homeController =
                                                  Get.find<HomeController>();
                                              homeController.refreshTargets();
                                              Get.back();
                                            },
                                            style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.zero)),
                                            child: GetBuilder<
                                                    TargetDetailController>(
                                                id: "appbar",
                                                builder: (controller) =>
                                                    SvgPicture.asset(
                                                      'assets/icons/common/chevron-left.svg',
                                                      width: 40,
                                                      height: 40,
                                                      color:
                                                          targetDetailController
                                                              .target
                                                              .targetColor,
                                                    ))),
                                      )),
                                  Positioned(
                                      top: 0,
                                      right: 15,
                                      bottom: 0,
                                      child: Container(
                                        width: 55,
                                        // color: Colors.orange,
                                        alignment: Alignment.center,
                                        child: TextButton(
                                            onPressed: () {
                                              //分享页面
                                              CupertinoScaffold
                                                  .showCupertinoModalBottomSheet(
                                                      context: context,
                                                      builder: (context) =>
                                                          SharePage(
                                                            originalWidgets: [
                                                              _renderTopTitleView(),
                                                              _renderCountDownView(),
                                                              _renderNotesView(
                                                                  context,
                                                                  buttonVisible:
                                                                      false),
                                                            ],
                                                            baseColor:
                                                                targetDetailController
                                                                    .target
                                                                    .targetColor!,
                                                          ),
                                                      enableDrag: true,
                                                      expand: true,
                                                      backgroundColor:
                                                          Colors.transparent);
                                            },
                                            style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.zero)),
                                            child: GetBuilder<
                                                TargetDetailController>(
                                              id: "appbar",
                                              builder: (controller) =>
                                                  SvgPicture.asset(
                                                      'assets/icons/common/share-ios.svg',
                                                      width: 35,
                                                      height: 35,
                                                      color:
                                                          targetDetailController
                                                              .target
                                                              .targetColor),
                                            )),
                                      )),
                                  GetBuilder<TargetDetailController>(
                                      id: "appbar",
                                      builder: (controller) {
                                        return targetDetailController
                                                    .target.targetStatus ==
                                                TargetStatus.processing
                                            ? Positioned(
                                                top: 0,
                                                right: 15 + 55,
                                                bottom: 0,
                                                child: Container(
                                                  width: 55,
                                                  // color: Colors.orange,
                                                  alignment: Alignment.center,
                                                  child: TextButton(
                                                      onPressed: () {
                                                        //编辑目标
                                                        controller.editTarget(
                                                            context);
                                                      },
                                                      style: ButtonStyle(
                                                          padding:
                                                              MaterialStateProperty
                                                                  .all(EdgeInsets
                                                                      .zero)),
                                                      child: SvgPicture.asset(
                                                        'assets/icons/common/edit.svg',
                                                        width: 35,
                                                        height: 35,
                                                        color:
                                                            targetDetailController
                                                                .target
                                                                .targetColor,
                                                      )),
                                                ))
                                            : Container();
                                      })
                                ],
                              )),
                          preferredSize: Size.fromHeight(55.0)),
                      //             NavigatorBar(
                      //                 title: "",
                      //                 baseColor: targetDetailController.target.targetColor,
                      //                 navigatorBarType: NavigatorBarType.detail_page,
                      //                 closeType: NavigatorBarCloseType.back,
                      //                 closeCallBack: () {
                      //                   Get.back();
                      //                 },
                      //                 editCallBack: () {
                      //                   CupertinoScaffold.showCupertinoModalBottomSheet(
                      //                       context: context,
                      //                       builder: (context) => TaskSelectPage(
                      //                             targetDetailController.target,
                      //                             taskEditMode: TaskEditMode.TaskEditMode_Edit,
                      //                           ),
                      //                       enableDrag: true,
                      //                       expand: true,
                      //                       backgroundColor: Colors.transparent);

                      //                   // Get.toNamed(Routes.SELECTTARGET);

                      // //                             Target updateTarget = Target()
                      // // ..id = 1
                      // // ..name = "戒小龙虾"
                      // // ..targetDays = 1
                      // // ..targetColor = Colors.yellow
                      // // ..notificationTimes = [];

                      // //   Get.toNamed(Routes.TARGETDETAIL, arguments: updateTarget, preventDuplicates: false);

                      //                 },
                      //                 shareCallBack: () {
                      //                   CupertinoScaffold.showCupertinoModalBottomSheet(
                      //                       context: context,
                      //                       builder: (context) => SharePage(
                      //                             originalWidgets: [
                      //                               _renderTopTitleView(),
                      //                               _renderCountDownView(),
                      //                               _renderNotesView(context,
                      //                                   buttonEnable: false),
                      //                             ],
                      //                             baseColor: targetDetailController
                      //                                 .target.targetColor!,
                      //                           ),
                      //                       enableDrag: true,
                      //                       expand: true,
                      //                       backgroundColor: Colors.transparent);
                      //                 }),
                      body: SafeArea(
                        child: GetBuilder<TargetDetailController>(
                          id: "all",
                          builder: (controller) => Container(
                              // color: Colors.white,
                              child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _renderTopTitleView(),
                                _renderCountDownView(),
                                _renderNotesView(context),
                                _renderGiveUpView()
                              ],
                            ),
                          )),
                        ),
                      ))))),
      // floatWidget: Material(
      //     color: Colors.transparent,
      //     child: Stack(children: [
      //       Container(
      //           color: Colors.orange.withOpacity(0.5),
      //           child: Lottie.asset('assets/animations/81296-success.json',
      //               width: 300,
      //               height: 300,
      //               fit: BoxFit.cover,
      //               repeat: false)),
      //       Positioned(
      //         left: 0,
      //         right: 0,
      //           top: 20,
      //           child: Container(
      //             child: Text("恭喜你，达成目标",
      //                 textAlign: TextAlign.center,
      //                 style: TextStyle(
      //                     fontSize: 30, fontWeight: FontWeight.w600)),
      //           ))
      //     ]))
    );
  }
}

class _CountDownView extends StatefulWidget {
  _CountDownView(
      {required this.beginTime, required this.targetDays, required this.color});
  final DateTime beginTime;
  final int targetDays;
  final Color color;

  @override
  State<StatefulWidget> createState() {
    return _CountDownViewState();
  }
}

class _CountDownViewState extends State<_CountDownView> {
  late Timer? _timer;
  int? _seconds;

  void _startTimer() {
//设置 1 秒回调一次
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      //更新界面
      setState(() {
        //秒数减一，因为一秒回调一次
        _seconds = _seconds! - 1;
      });
      if (_seconds == 0) {
        //倒计时秒数为0，取消定时器
        _cancelTimer();

        //更改目标状态为完成
        
      }
    });
  }

  void _cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void initState() {
    super.initState();

    //计算目标计算时间(目标开始时间+目标设置天数)
    DateTime endTime = widget.beginTime.add(Duration(days: widget.targetDays));

    Duration diff = endTime.difference(DateTime.now());

    _seconds = diff.inSeconds;

    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 166,
      alignment: Alignment.center,
      child: Text(second2DHMS(_seconds!),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: widget.color,
              fontSize: 18.0,
              fontWeight: FontWeight.w400)),
    );
  }
}

// --------------------------------------------------------------------------------
class TextFiledRightDialog extends AlertDialog {
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

  TextFiledRightDialog({this.bgColor}) : super(backgroundColor: bgColor);
  final Color? bgColor;

  @override
  Widget get content => DialogContent();
}

class DialogContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DialogContentState();
}

class DialogContentState extends State<DialogContent> {
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.orange,
      child: Wrap(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text("Test Right Dialog"),
              TextField(
                autofocus: true,
              )
            ],
          )
        ],
      ),
    );
  }
}

class _JouneryItemWidget extends StatefulWidget {
  _JouneryItemWidget(
      {required this.jounery,
      this.isFirstItem = false,
      this.isLastItem = false,
      this.isOnlyOneItem = false,
      required this.baseColor});
  final Jounery jounery;
  final bool isFirstItem;
  final bool isLastItem;
  final bool isOnlyOneItem;
  final Color baseColor;

  @override
  State<StatefulWidget> createState() {
    return _JouneryItemState();
  }
}

class _JouneryItemState extends State<_JouneryItemWidget> {
  ValueNotifier<double?> totalheightValue = ValueNotifier<double?>(null);

  double circulSize = 14.0;

  @override
  void initState() {
    super.initState();

    //该Widget绘制结束后的回调，可以在这个回调里获取widget的高度
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // print("+++++++整个View获取高度${this.context.size!.height}+++++");
      totalheightValue.value = this.context.size!.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: this.totalheightValue,
        builder: (context, height, child) {
          print("-----$height-------");
          return Container(
            // color: Colors.red,
            // padding: EdgeInsets.symmetric(vertical: 20),
            child: Stack(
              // fit: StackFit.expand,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: circulSize,
                      height: circulSize,
                      decoration: BoxDecoration(
                          color: widget.baseColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(circulSize / 2))),
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(left: 20),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              formatTime(
                                      formatter: formatter_2,
                                      time: widget.jounery.createTime) ??
                                  "",
                              style: TextStyle(
                                  color: textBlackColor, fontSize: 14)),
                          Text("${widget.jounery.text}",
                              style: TextStyle(
                                  color: widget.baseColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ))
                  ],
                ),
                // widget.isOnlyOneItem == true ? Container() : (

                // )

                //上线
                height != null
                    ? widget.isOnlyOneItem == false
                        ? (widget.isFirstItem == true
                            ? Container()
                            : Positioned(
                                top: 0,
                                left: circulSize / 2 - 1,
                                child: Container(
                                    width: 2,
                                    height: this.totalheightValue.value! / 2 -
                                        circulSize / 2 -
                                        8,
                                    color: widget.baseColor)))
                        : Container()
                    : Container(),
                //下线
                height != null
                    ? widget.isOnlyOneItem == false
                        ? (widget.isLastItem == true
                            ? Container()
                            : Positioned(
                                bottom: 0,
                                left: circulSize / 2 - 1,
                                child: Container(
                                    width: 2,
                                    height: this.totalheightValue.value! / 2 -
                                        circulSize / 2 -
                                        8,
                                    color: widget.baseColor)))
                        : Container()
                    : Container(),
              ],
            ),
          );
        });
  }
}
