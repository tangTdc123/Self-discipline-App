
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'dart:ui' as ui;

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quit_product/common/config.dart';
import 'package:quit_product/common/widgets/common_widget.dart';
import 'package:quit_product/utils/object_util.dart';
import 'package:quit_product/utils/permission.dart';

class SharePage extends StatefulWidget {
  SharePage({this.originalWidgets, this.baseColor = Colors.blue});

  final List<Widget>? originalWidgets;
  final Color baseColor;

  @override
  State<StatefulWidget> createState() {
    return SharePageState();
  }
}

class SharePageState extends State<SharePage> {
  final GlobalKey repaintWidgetKey = GlobalKey(); // 绘图key值

  bool _shareButtonVisible = false;

  @override
  void initState() {
    super.initState();

    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.light
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.white.withOpacity(0.9)
      ..boxShadow = [] //这么设置，backgroundColor设置透明度才有效
      ..indicatorColor = widget.baseColor
      ..textColor = Colors.yellow
      ..maskColor = Colors.black45
      ..userInteractions = false
      ..dismissOnTap = false;
    // ..customAnimation = CustomAnimation();

    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.instance.maskType = EasyLoadingMaskType.custom;
    // EasyLoading.instance.animationStyle = EasyLoadingAnimationStyle.custom;

    EasyLoading.show();

    Future.delayed(Duration(milliseconds: 2500), () {
      EasyLoading.dismiss();

      setState(() {
        _shareButtonVisible = true;
      });
    });
  }

  List<Widget> _renderWidgets() {
    List<Widget> widgets = [];

    widgets.add(Container(
      // color:Colors.white,
      // margin: EdgeInsets.only(left: 20, right: 20),
      // // padding: EdgeInsets.only(top:20, bottom: 20),
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Stack(
        // fit: StackFit.expand,
        children: [
          Container(
              margin: EdgeInsets.only(top: 30, bottom: 30),

              // color: Colors.orange,
              width: double.infinity,
              height: 200,
              child: Lottie.asset('assets/animations/77378-sunset.json')
              // SvgPicture.asset(
              //   'assets/illustrations/share/summer-camp.svg',
              //   width: double.infinity,
              //   height: 200,
              //   fit: BoxFit.cover,
              // ),
              ),
          Positioned(
              right: 10,
              bottom: 5,
              child: Text("Dzeaze on lottiefiles.com",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: textGreyColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)))
        ],
      ),
    ));

    if (!ObjectUtil.isEmptyList(widget.originalWidgets)) {
      widgets.addAll(widget.originalWidgets!);
    }

    // widgets.add(Container(
    //   color: Colors.orange,
    //   height: 100,
    //   child: Text("APP 二维码下载图片"),
    // ));

    return widgets;
  }

  void _saveImageToDisk(BuildContext ctx) async {
    //手机相册权限
    try {
      bool? galleryCanUse = await PermissionManager.requestPhotosPermission();

      if (galleryCanUse == null || galleryCanUse == false) {
        //弹框让用户去设置里打开相册权限
        showDialog(
            context: ctx,
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
                                  child: Text('go to setting'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: textBlackColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 15, left: 30, right: 30),
                                  child: Text('album permission'.tr,
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
                                          Navigator.of(context).pop();
                                          Future.delayed(
                                              Duration(milliseconds: 300), () {
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
                                                          239, 240, 241, 1)))),
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
        return;
      }
    } catch (e) {}

    BuildContext? buildContext = repaintWidgetKey.currentContext;
    if (buildContext != null) {
      RenderRepaintBoundary boundary =
          buildContext.findRenderObject()! as RenderRepaintBoundary;

      double dpr = ui.window.devicePixelRatio; // 获取当前设备的像素比

      ui.Image image = await boundary.toImage(pixelRatio: dpr);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        /// return Map type
        /// for example:{"isSuccess":true, "filePath":String?}
        ///
        Map? result;
        try {
          result =
              await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
        } catch (e) {
          print(e);
        }

        if (!ObjectUtil.isEmptyMap(result)) {
          bool? isSuccess = result!["isSuccess"];
          if (isSuccess != null && isSuccess == true) {
            //保存成功
            showCustomToast('save success'.tr);
            return;
          }
        }
      }
    }

    showCustomToast('save failed'.tr);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Scaffold(
            body: SafeArea(
                child: Container(
                    color: Color.fromRGBO(244, 245, 246, 1),
                    child: Stack(children: [
                      Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          child: Container(
                              height: 60,
                              // color: Colors.white,
                              child: _shareButtonVisible == true
                                  ? Stack(
                                      children: [
                                        Positioned(
                                            top: 10,
                                            right: 15,
                                            bottom: 10,
                                            child: Container(
                                              width: 40,
                                              // color: Colors.white,
                                              alignment: Alignment.center,
                                              child: TextButton(
                                                  onPressed: () {
                                                    //保存图片
                                                    _saveImageToDisk(context);
                                                  },
                                                  style: ButtonStyle(
                                                      padding:
                                                          MaterialStateProperty
                                                              .all(EdgeInsets
                                                                  .zero)),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/common/download.svg',
                                                    width: 28,
                                                    height: 28,
                                                    color: widget.baseColor,
                                                  )),
                                            )),
                                        // Positioned(
                                        //     top: 10,
                                        //     right: 15 + 40,
                                        //     bottom: 10,
                                        //     child: Container(
                                        //       width: 40,
                                        //       // color: Colors.red,
                                        //       alignment: Alignment.center,
                                        //       child: TextButton(
                                        //           onPressed: () {},
                                        //           style: ButtonStyle(
                                        //               padding:
                                        //                   MaterialStateProperty.all(
                                        //                       EdgeInsets.zero)),
                                        //           child: SvgPicture.asset(
                                        //               'assets/icons/common/download.svg',
                                        //               width: 28,
                                        //               height: 28
                                        //               // color: Colors.blue,
                                        //               )),
                                        //     ))
                                      ],
                                    )
                                  : Container())),
                      Positioned(
                          left: 0,
                          right: 0,
                          top: 60,
                          bottom: 0,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: RepaintBoundary(
                                //注意不在包在SingleChildScrollView的外层，否则生成的图片不包括离屏的widget
                                key: repaintWidgetKey,
                                child: Container(color: Color.fromRGBO(244, 245, 246, 1),child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _renderWidgets(),
                                ))),
                          ))
                    ])))));
  }
}

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}
