import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:quit_product/common/config.dart';
import 'package:quit_product/common/widgets/navigator_bar%20copy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 245, 246, 1),
      appBar: NavigatorBar(
          title: 'help'.tr,
          closeCallBack: () {
            Get.back();
          }),
      body: SafeArea(
        child: Container(
          // color: Colors.orange,
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      // if (Platform.isIOS) {
                      //   //跳转app store 评分
                      // } else if (Platform.isAndroid) {
                      //   //跳转google play 评分
                      // }

                      LaunchReview.launch(
                        androidAppId: "com.xinle.asceticism",
                        iOSAppId: "todo"
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: 70,
                      margin: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      child: Text('praise'.tr,
                          style: TextStyle(
                              color: textBlackColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w500)),
                    )),
                Container(
                    height: 1,
                    margin: EdgeInsets.only(left: 15),
                    width: double.infinity,
                    color: Color.fromRGBO(234, 238, 239, 1)),
                GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          isScrollControlled: true, //必须设置这个，否则高度不能控制
                          enableDrag: false,
                          builder: (ctx) {
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.transparent,
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 260,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0)),
                                          color: Colors.white),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(top: 20),
                                              child: Text('contact me'.tr,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: textBlackColor,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                          Container(
                                            margin: EdgeInsets.only(top: 30),
                                            // height: 40,
                                            // color: Colors.orange,
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/common/email.svg',
                                                    width: 30,
                                                    height: 30,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                // Expanded(
                                                //     child:
                                                Text("zhouxinle2012@163.com",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: textBlackColor,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500))
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 20),
                                            height: 40,
                                            // color: Colors.orange,
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/common/wechat.svg',
                                                    width: 25,
                                                    height: 25,
                                                  ),
                                                ),
                                                // Expanded(
                                                //     child:
                                                Text("ashen607680",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        color: textBlackColor,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ))
                              ],
                            );
                          });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 70,
                      margin: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      color: Colors.white,
                      child: Text('feedback'.tr,
                          style: TextStyle(
                              color: textBlackColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w500)),
                    )),
                Container(
                    height: 1,
                    margin: EdgeInsets.only(left: 15),
                    width: double.infinity,
                    color: Color.fromRGBO(234, 238, 239, 1)),
                GestureDetector(
                  onTap: () {
                    //跳转系统浏览器
                    //获取当前locale 手机设置里面设置的 语言和地区
                    Locale currentLocale = ui.window.locale;

                    if (currentLocale.languageCode == 'zh') {
                      //中文，不管是简体、繁体、香港、澳门、台湾等，都使用简体中文
                      launch("https://shimo.im/docs/pvTHxYrvqkxPXjwG/");
                    } else {
                      launch("https://shimo.im/docs/VkGYJYDvWpddHTpG/");
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      height: 70,
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      child: Text('policy'.tr,
                          style: TextStyle(
                              color: textBlackColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w500))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
