import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quit_product/common/config.dart';
import 'package:quit_product/models/illustrations.dart';
import 'package:quit_product/pages/splash/splash_controller.dart';
import 'package:quit_product/routes/app_routes.dart';
import 'package:quit_product/utils/common.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _PageViewWidget(),
    );
  }
}

class _PageViewWidget extends StatefulWidget {
  _PageViewWidget({Key? key}) : super(key: key);
  @override
  State<_PageViewWidget> createState() => __PageViewWidgetState();
}

class __PageViewWidgetState extends State<_PageViewWidget> {
  SplashController splashController = Get.find<SplashController>();
  int _currentIndex = 0;
  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    _pageController = new PageController(
      ///用来配置PageView中默认显示的页面 从0开始
      initialPage: 0,
      keepPage: false,
    );
    return Container(
      child: GestureDetector(
          onTapDown: (details) => {
                if (details.localPosition.dx <
                    MediaQuery.of(context).size.width / 2)
                  {
                    if (_currentIndex > 0)
                      {
                        _pageController.animateToPage(_currentIndex - 1,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.ease)
                      }
                  }
                else
                  {
                    if (_currentIndex < 1)
                      {
                        _pageController.animateToPage(_currentIndex + 1,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.ease)
                      }
                  }
              },
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    if (index > splashController.illustrations.length - 1)
                      return SizedBox.shrink();
                    return StartColum(index, splashController);
                  }),
              Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).padding.bottom + 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 8,
                      width: 8,
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == 0
                              ? Colors.grey
                              : Colors.grey.withOpacity(0.7)),
                    ),
                    Container(
                      height: 8,
                      width: 8,
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == 1
                              ? Colors.grey
                              : Colors.grey.withOpacity(0.7)),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class StartColum extends StatelessWidget {
  int index;
  SplashController splashController;
  StartColum(this.index, this.splashController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Illustrations illustrations = splashController.illustrations[index];
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        margin:
            EdgeInsets.only(top: Get.height / 2 - (Get.width - 40) / 2 - 50),
        child: SvgPicture.asset(
          illustrations.asset!,
          height: Get.width - 40,
        ),
      ),
      index == splashController.illustrations.length - 1
          ? Container(
              margin: EdgeInsets.only(top: 30),
              width: 260,
              height: 50,
              child: TextButton(
                onPressed: () {
                  Get.toNamed(Routes.HOME);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => commonGreenColor),
                    textStyle: MaterialStateProperty.all(TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                      fontFamily: getFontFamilyByLanguage(),
                    )),
                    foregroundColor: MaterialStateProperty.all(textBlackColor),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0)))),
                child: Text('开启健康生活'),
              ))
          : Container(
              margin: EdgeInsets.only(top: 30),
              width: 220,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                '远离不良饮食',
                style: TextStyle(
                    color: textBlackColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
            )
    ]);
    ;
  }
}
