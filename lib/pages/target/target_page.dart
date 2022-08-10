import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quit_product/common/config.dart';
import 'package:quit_product/common/widgets/navigator_bar.dart';
import 'package:quit_product/models/target.dart';
import 'package:quit_product/pages/target/target_controller.dart';
import 'package:quit_product/pages/target/target_edit.dart';

class TargetPage extends StatelessWidget {
  final TargetController targetController = Get.find<TargetController>();

  Widget _renderTargetItem(Target? target, int index, BuildContext context) {
    if (target == null) return SizedBox.shrink();
    return InkWell(
        onTap: () {
          // Target updateTarget = Target()
          //   ..id = 1
          //   ..name = "戒小龙虾"
          //   ..targetDays = 1
          //   ..targetColor = Colors.yellow
          //   ..createTime = DateTime.now()
          //   ..notificationTimes = [];

          //      Get.until((route) {
          //   if (route.settings.name == Routes.HOME) {
          //     return true;
          //   }
          //   return false;
          // });

          // Future.delayed(Duration(seconds: 1), (){
          // Get.toNamed(Routes.TARGETDETAIL, arguments: updateTarget);

          // });

          // Get.offNamedUntil(Routes.TARGETDETAIL, (route) {
          //   if (route.settings.name == Routes.HOME) {
          //     return true;
          //   }
          //   return false;
          // }, arguments: updateTarget, parameters: {"tag": "${++Tags.tag}"});

          CupertinoScaffold.showCupertinoModalBottomSheet(
              context: context,
              builder: (context) => TargetEditPage(target),
              enableDrag: true,
              expand: true,
              backgroundColor: Colors.transparent);

          // showCupertinoModalBottomSheet(context: context, builder: (ctx){
          //   return TaskSelectPage();
          // });
        },
        child: Container(
          margin: EdgeInsets.only(
              top: index == 0 ? 30 : 15,
              left: 30,
              right: 30,
              bottom: index == targetController.targets.length - 1 ? 30 : 15),
          height: 80,
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
              color: target.targetColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(target.name ?? "",
                                style: TextStyle(
                                  color: textBlackColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            child: Text(target.description ?? "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w300,
                                )),
                          ),
                        ],
                      ))),
            ],
          ),
        ));
  }

  TargetPage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(body: CupertinoPageScaffold(child: 
    Scaffold(
        appBar: NavigatorBar(
            title: 'challenge_target'.tr,
            closeCallBack: () {
                              Get.back();
            }),
        body: SafeArea(
            child: LiveList(
                // showItemInterval: Duration(microseconds: 200),
                // showItemDuration: Duration(microseconds: 200),
                visibleFraction: 0.05,
                reAnimateOnVisibility: false,
                itemBuilder: ((context, index, animation) {
                  return FadeTransition(
                                        opacity: Tween<double>(
                                          begin: 0,
                                          end: 1,
                                        ).animate(animation),
                                        // And slide transition
                                        child: SlideTransition(
                                            position: Tween<Offset>(
                                              begin: Offset(0, -0.1),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            // Paste you Widget
                                            child: _renderTargetItem(
                                                targetController.targets[index],
                                                index,
                                                context)),
                                      ); 
                }),
                itemCount: targetController.targets.length))))) ;
  }
}
class ModalFit extends StatelessWidget {
  const ModalFit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Edit'),
            leading: Icon(Icons.edit),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Copy'),
            leading: Icon(Icons.content_copy),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Cut'),
            leading: Icon(Icons.content_cut),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Move'),
            leading: Icon(Icons.folder_open),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Delete'),
            leading: Icon(Icons.delete),
            onTap: () => Navigator.of(context).pop(),
          )
        ],
      ),
    ));
  }
}
