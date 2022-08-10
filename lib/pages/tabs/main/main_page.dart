import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quit_product/common/config.dart';
import 'package:quit_product/models/exercise.dart';
import 'package:quit_product/models/target.dart';
import 'package:quit_product/pages/tabs/main/main_controller.dart';
import 'package:quit_product/utils/color.dart';
import 'package:quit_product/utils/date_time.dart';

class MainPage extends StatelessWidget {
  final MainController mainController = Get.find<MainController>();

  Widget _renderTargetItem(
      MainController mainController, int index, BuildContext context) {
    Target target = mainController.savedTargets[index];

    return GestureDetector(
        onTap: () {
          mainController.pushToTaskDetailPage(target);
        },
        child: Container(
            height: 80,
            margin: EdgeInsets.only(
                left: 20,
                right: 20,
                top: index == 0 ? 20 : 10,
                bottom:
                    index == mainController.savedTargets.length - 1 ? 20 : 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: lighten(target.targetColor!, 55)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Stack(
              fit: StackFit.expand,
              children: [
                //进行中的目标上方的进度浮层
                target.targetStatus == TargetStatus.processing
                    ? Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: _caculateWidth(target),
                          decoration: BoxDecoration(
                              // borderRadius: BorderRadius.only(
                              //     topLeft: Radius.circular(10),
                              //     bottomLeft: Radius.circular(10),
                              //     topRight: Radius.circular(0),
                              //     bottomRight: Radius.circular(0)),
                              color: target.targetColor),
                        ))
                    : Container(),
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${target.name}",
                                  style: TextStyle(
                                      color: textBlackColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18)),
                              Container(
                                  margin: EdgeInsets.only(top: 4),
                                  child: Text(
                                      "${'start_at'.tr} ${formatTime(formatter: formatter_2, time: target.createTime)}",
                                      style: TextStyle(
                                          color:
                                              textBlackColor.withOpacity(0.6),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)))
                            ])),
                    Expanded(
                        child: target.targetStatus == TargetStatus.processing
                            ? Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Text(
                                    "${_caculateProcessingDays(target) ?? ''}/${target.targetDays} ${'days'.tr}",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: textBlackColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20)),
                              )
                            : (target.targetStatus == TargetStatus.completed
                                ? Container(
                                    margin: EdgeInsets.only(right: 15),
                                    alignment: Alignment.centerRight,
                                    child: SvgPicture.asset(
                                        "assets/icons/common/beaming-face-with-smiling-eyes.svg",
                                        width: 35,
                                        height: 35),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(right: 15),
                                    alignment: Alignment.centerRight,
                                    child: SvgPicture.asset(
                                        "assets/icons/common/disappointed-face.svg",
                                        width: 35,
                                        height: 35),
                                  )))
                  ],
                )
              ],
            )));
  }

  double _caculateWidth(Target target) {
    double fullWidth = Get.width - 40 - 20;

    int total = Duration(days: target.targetDays!).inSeconds;
    int duration = DateTime.now().difference(target.createTime!).inSeconds;
    double process = duration / total;

    return fullWidth * process;
  }

  int? _caculateProcessingDays(Target target) {
    DateTime? createTime = target.createTime;

    if (createTime == null) return null;

    return diffdaysBetweenTwoDate(createTime, DateTime.now());
  }



  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: double.infinity,
    //   height: double.infinity,
    //   color: Colors.blue,
    // );
  Widget _renderLottieWidget(int index) {
    return Lottie.asset(mainController.exerciseLotties[index].asset);
  }
    return CupertinoScaffold(
        body: Builder(
            builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
                // 这里设置导航栏颜色
                value: SystemUiOverlayStyle.dark,
                child: CupertinoPageScaffold(
                    child: Scaffold(
                        backgroundColor: const Color.fromRGBO(244, 245, 246, 1),
                        body: SafeArea(
                            top: false,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              // color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                      onTap: () => {
                        print(mainController.exerciseLotties)

                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 230,
                                        margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .padding
                                                  .top +
                                              10,
                                          left: 10,
                                          right: 10,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: mainController
                                                    .exerciseLotties.length ==
                                                0
                                            ? Container()
                                            : CarouselSlider.builder(
                                                itemCount: mainController
                                                    .exerciseLotties.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index,
                                                        int realIndex) {
                                                  // Exercise exercise =
                                                  //     mainController
                                                  //             .exerciseLotties[
                                                  //         index];
                                                  return Stack(children: [
                                                    Container(
                                                        width: double.infinity,
                                                        height: 230,
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            _renderLottieWidget(
                                                                index)),
                                                    // Positioned(
                                                    //     right: 10,
                                                    //     bottom: 10,
                                                    //     child: Text(
                                                    //         exercise.copyright ??
                                                    //             "",
                                                    //         textAlign:
                                                    //             TextAlign.right,
                                                    //         style: TextStyle(
                                                    //             color:
                                                    //                 textGreyColor,
                                                    //             fontSize: 14,
                                                    //             fontWeight:
                                                    //                 FontWeight
                                                    //                     .w400)))
                                                  ]);
                                                },
                                                options: CarouselOptions(
                                                    disableCenter: true,
                                                    // height: 300,
                                                    viewportFraction: 1,
                                                    autoPlay: true,
                                                    autoPlayInterval:
                                                        Duration(seconds: 4))),
                                      )),
                                  Expanded(
                                    child: GetBuilder<MainController>(builder: (controller){
                                      return Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    print("-------");
                                                    controller.showFilterView();
                                                    
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: 15,
                                                        left: 20,
                                                        bottom: 2),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                        color: commonGreenColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    6))),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          controller
                                                                .getFilterTitle(),
                                                            // controller
                                                            //     .getFilterTitle(),
                                                            style: TextStyle(
                                                                color:
                                                                    textBlackColor,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 4),
                                                          child: SvgPicture.asset(
                                                              'assets/icons/common/filters.svg',
                                                              width: 18,
                                                              height: 18,
                                                              color:
                                                                  textBlackColor),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                                  Expanded(child: Stack(fit: StackFit.expand,
                                                  children: [
                                                    GetBuilder<MainController>(id: 'list_view',builder: (Controller){
                                                      return SmartRefresher(controller: mainController.refreshController,
                                                      enablePullDown: true,
                                                      enablePullUp: false,
                                                      header: ClassicHeader(
                                                          idleText:
                                                              'refresh_idle_text'
                                                                  ,
                                                          releaseText:
                                                              'refresh_releasing_text'
                                                                  ,
                                                          completeText:
                                                              'refresh_complete_text'
                                                                  ,
                                                      ),
                                                      onRefresh: () {
                                                          mainController
                                                              .refreshList();
                                                        },
                                                      child: ListView.builder(
                                                        padding: EdgeInsets.zero,
                                                        itemCount: mainController.savedTargets.length,
                                                        itemBuilder: (context,index){
                                                        return _renderTargetItem(
                                                                  mainController,
                                                                  index,
                                                                  context);
                                                      }),);
                                                    }),
                                                    Positioned(
                                                    right: 20,
                                                    bottom: 20,
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          mainController.jumpSelectTargetPage();
                                                        },
                                                        child: Container(
                                                          child:
                                                              SvgPicture.asset(
                                                              'assets/icons/common/add_target.svg',
                                                            color: Colors.blue,
                                                            width: 50,
                                                            height: 50,
                                                          ),
                                                        )))

                                                  ],))
                                                  
                                                  
                                                  
                                                  ])
                                    );
                                    })
                                  ),
                                ],
                              ),
                            )))))));
  }
}
