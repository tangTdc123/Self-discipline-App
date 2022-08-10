
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quit_product/common/config.dart';
import 'package:quit_product/common/widgets/navigator_bar.dart';
import 'package:quit_product/pages/tabs/exercise/exercise_controller.dart';
import 'package:quit_product/pages/tabs/exercise/exercise_detail_page.dart';
import 'package:quit_product/routes/app_routes.dart';
import 'package:quit_product/utils/object_util.dart';

class ExercisePage extends StatelessWidget {
  final ExerciseController exerciseController = Get.find<ExerciseController>(
      tag: Get.arguments == null ? null : Get.arguments["from"]);

  @override
  Widget build(BuildContext context) {
    print("buildPage");
    return CupertinoScaffold(
        body: Builder(
      builder: (context_1) => AnnotatedRegion<SystemUiOverlayStyle>(
          // 这里设置导航栏颜色
          value: SystemUiOverlayStyle.dark,
          child: CupertinoPageScaffold(
              child: Scaffold(
            backgroundColor: const Color.fromRGBO(242, 243, 244, 1),
            appBar: ObjectUtil.isEmptyString(exerciseController.from)
                ? null
                : NavigatorBar(
                    title: "",
                    closeType: NavigatorBarCloseType.back,
                    closeCallBack: () {
                      Get.back();
                    }),
            body: SafeArea(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: double.infinity,
                        height: 40,
                        margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Text('exercises'.tr,
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600,
                                        color: textBlackColor))),
                            GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.HELP);
                                },
                                child: Container(
                                  width: 80,
                                  height: 40,
                                  // color:Colors.orange,
                                  alignment: Alignment.centerRight,
                                  child: SvgPicture.asset(
                                    'assets/icons/common/more.svg',
                                    width: 30,
                                    height: 30,
                                  ),
                                ))
                          ],
                        )),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 20),
                      padding: EdgeInsets.only(
                          top: 20, bottom: 20, left: 10, right: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: GridView.builder(
                          itemCount: exerciseController.exerciseList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.62,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  // HomeController homeController = Get.find<HomeController>();
                                  // homeController.showExercisePage(exerciseController
                                  //                 .exerciseList[index]);

                                  CupertinoScaffold
                                      .showCupertinoModalBottomSheet(
                                          context: context_1,
                                          builder: (context) =>
                                              ExerciseDetailPage(
                                                  exercise: exerciseController
                                                      .exerciseList[index]),
                                          enableDrag: true,
                                          expand: true,
                                          backgroundColor: Colors.transparent);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(250, 250, 250, 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(0))),
                                  padding: EdgeInsets.only(
                                      top: 8, left: 5, right: 5, bottom: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          // color: Colors.orange,
                                          alignment: Alignment.center,
                                          child: Lottie.asset(
                                              exerciseController
                                                  .exerciseList[index].asset,
                                              width:
                                                  (Get.width - 40 - 20 - 10) /
                                                          2 -
                                                      20,
                                              height:
                                                  (Get.width - 40 - 20 - 10) /
                                                          2 -
                                                      20)),
                                      Container(
                                        width: double.infinity,
                                        margin:
                                            EdgeInsets.only(left: 5, top: 5),
                                        child: Text(
                                            exerciseController
                                                .exerciseList[index].name,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: textBlackColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 5, top: 1),
                                        width: double.infinity,
                                        child: Text(
                                            exerciseController
                                                    .exerciseList[index]
                                                    .effect ??
                                                "",
                                            textAlign: TextAlign.left,
                                            // softWrap:true,
                                            style: TextStyle(
                                                color: textGreyColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300)),
                                      ),
                                      // Container(
                                      //   child: Text("@copyright,copyrightcopyrightcopyright", style: TextStyle(fontSize: 12)),
                                      // )
                                    ],
                                  ),
                                ));
                          }),
                    ))
                  ],
                ),
              ),
            ),
          ))),
    ));
  }
}
