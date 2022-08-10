import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

enum NavigatorBarType { common, detail_page }

enum NavigatorBarCloseType {
  close,
  back,
}

class NavigatorBar extends StatelessWidget implements PreferredSizeWidget {
  // required值，表示该属性一定有值，final String title这样定义是不会报错的

  // this.height 表示该属性可能会没有值，final double height这样定义就会报错，因为final double height表示在构造函数中必须初始化，可以给加上? 或者 this.height=100默认值
  // this.target没有加{}，表示是必选参数，和@required是一样的
  // class TaskSelectPage extends StatefulWidget {
  // // final HomeController homeController = Get.find<HomeController>();

  // // this.target没有加{}，表示是必选参数，和@required是一样的
  // TaskSelectPage(this.target);

  // final Target target;
  const NavigatorBar(
      {Key? key,
      this.bgColor = const Color.fromRGBO(244, 245, 246, 1),
      required this.title,
      this.height = 55.0,
      this.navigatorBarType = NavigatorBarType.common,
      this.closeType = NavigatorBarCloseType.close,
      this.closeCallBack,
      this.editCallBack,
      this.shareCallBack,
      this.baseColor = Colors.blue})
      : super(key: key);

  final NavigatorBarType? navigatorBarType;
  final NavigatorBarCloseType? closeType;
  final double? height;
  final Color? bgColor;
  final String title;
  final Function? closeCallBack;
  final Function? shareCallBack;
  final Function? editCallBack;
  final Color? baseColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: this.bgColor,
        padding:
            EdgeInsets.fromLTRB(0, Get.context!.mediaQueryPadding.top, 0, 0),
        child: Stack(
          children: [
            Positioned(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(this.title,
                        style: TextStyle(
                            fontSize: 22,
                            color: this.baseColor,
                            fontWeight: FontWeight.w600)))),
            Positioned(
                top: 0,
                left: 10,
                bottom: 0,
                child: Container(
                  width: this.height,
                  // color: Colors.orange,
                  alignment: Alignment.center,
                  child: TextButton(
                      onPressed: () {
                        this.closeCallBack?.call();
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: closeType == NavigatorBarCloseType.close
                          ? SvgPicture.asset(
                              'assets/icons/common/close.svg',
                              width: 35,
                              height: 35,
                              color: this.baseColor,
                            )
                          : SvgPicture.asset(
                              'assets/icons/common/chevron-left.svg',
                              width: 40,
                              height: 40,
                              color: this.baseColor,
                            )),
                )),
            this.navigatorBarType == NavigatorBarType.detail_page
                ? Positioned(
                    top: 0,
                    right: 15,
                    bottom: 0,
                    child: Container(
                      width: this.height,
                      // color: Colors.orange,
                      alignment: Alignment.center,
                      child: TextButton(
                          onPressed: () {
                            this.shareCallBack?.call();
                          },
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          child: SvgPicture.asset(
                            'assets/icons/common/share-ios.svg',
                            width: 35,
                            height: 35,
                            color: this.baseColor,
                          )),
                    ))
                : Container(),
            this.navigatorBarType == NavigatorBarType.detail_page
                ? Positioned(
                    top: 0,
                    right: 15 + this.height!,
                    bottom: 0,
                    child: Container(
                      width: this.height,
                      // color: Colors.orange,
                      alignment: Alignment.center,
                      child: TextButton(
                          onPressed: () {
                            this.editCallBack?.call();
                          },
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          child: SvgPicture.asset(
                            'assets/icons/common/edit.svg',
                            width: 35,
                            height: 35,
                            color: this.baseColor,
                          )),
                    ))
                : Container(),
          ],
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(this.height!);
}
