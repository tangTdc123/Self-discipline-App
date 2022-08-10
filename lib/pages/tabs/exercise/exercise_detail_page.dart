
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lottie/lottie.dart';
import 'package:quit_product/common/config.dart';
import 'package:quit_product/models/exercise.dart';
import 'package:quit_product/utils/object_util.dart';

class ExerciseDetailPage extends StatelessWidget {
  ExerciseDetailPage({required this.exercise});
  final Exercise exercise;

  Widget _renderActionWidget() {
    if (ObjectUtil.isEmptyList(exercise.actions)) return Container();

    List<Widget> actionWidgets = exercise.actions!
        .map<Widget>((e) => Container(
              // alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(vertical: 2),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                ),
                Expanded(
                    child: Text(e,
                        style: TextStyle(
                            color: Color.fromRGBO(106, 115, 129, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.w300)))
              ]),
            ))
        .toList();

    // List<Widget> actionWidgets = [];

    actionWidgets.insert(
        0,
        Container(
            height: 38,
            alignment: Alignment.centerLeft,
            child: Text('exercise_steps'.tr,
                style: TextStyle(
                    color: Color.fromRGBO(
                        69, 80, 97, 1), // Color.fromRGBO(106, 115, 129, 1)
                    fontSize: 17,
                    fontWeight: FontWeight.w500))));

    return Container(
      // color: Colors.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: actionWidgets,
      ),
    );
  }

  Widget _renderBreathWidget() {
    if (ObjectUtil.isEmptyList(exercise.breaths)) return Container();

    List<Widget> actionWidgets = exercise.breaths!
        .map<Widget>((e) => Container(
              // alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(vertical: 2),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                ),
                Expanded(
                    child: Text(e,
                        style: TextStyle(
                            color: Color.fromRGBO(106, 115, 129, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.w300)))
              ]),
            ))
        .toList();

    // List<Widget> actionWidgets = [];

    actionWidgets.insert(
        0,
        Container(
            height: 38,
            alignment: Alignment.centerLeft,
            child: Text('exercise_breath'.tr,
                style: TextStyle(
                    color: Color.fromRGBO(
                        69, 80, 97, 1), // Color.fromRGBO(106, 115, 129, 1)
                    fontSize: 17,
                    fontWeight: FontWeight.w500))));

    return Container(
      // color: Colors.orange,
      margin: EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: actionWidgets,
      ),
    );
  }

  Widget _renderErrorWidget() {
    if (ObjectUtil.isEmptyList(exercise.errors)) return Container();

    List<Widget> actionWidgets = exercise.errors!
        .map<Widget>((e) => Container(
              // alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(vertical: 2),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                ),
                Expanded(
                    child: Text(e,
                        style: TextStyle(
                            color: Color.fromRGBO(106, 115, 129, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.w300)))
              ]),
            ))
        .toList();

    // List<Widget> actionWidgets = [];

    actionWidgets.insert(
        0,
        Container(
            height: 38,
            alignment: Alignment.centerLeft,
            child: Text("常见错误",
                style: TextStyle(
                    color: Color.fromRGBO(
                        69, 80, 97, 1), // Color.fromRGBO(106, 115, 129, 1)
                    fontSize: 17,
                    fontWeight: FontWeight.w500))));

    return Container(
      // color: Colors.orange,
      margin: EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: actionWidgets,
      ),
    );
  }

  Widget _renderTargetWidget() {
    if (ObjectUtil.isEmptyList(exercise.targets)) return Container();

    List<Widget> actionWidgets = exercise.targets!
        .map<Widget>((e) => Container(
              // alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(vertical: 2),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                ),
                Expanded(
                    child: Text(e,
                        style: TextStyle(
                            color: Color.fromRGBO(106, 115, 129, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.w300)))
              ]),
            ))
        .toList();

    // List<Widget> actionWidgets = [];

    actionWidgets.insert(
        0,
        Container(
            height: 38,
            alignment: Alignment.centerLeft,
            child: Text('exercise_goal'.tr,
                style: TextStyle(
                    color: Color.fromRGBO(
                        69, 80, 97, 1), // Color.fromRGBO(106, 115, 129, 1)
                    fontSize: 17,
                    fontWeight: FontWeight.w500))));

    return Container(
      // color: Colors.orange,
      margin: EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: actionWidgets,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              // color: Colors.orange,
              alignment: Alignment.center,
              child: Lottie.asset(exercise.asset, width: 280, height: 280),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(right: 20),
              child: Text(exercise.copyright ?? "",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: textGreyColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14)),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(exercise.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(
                          69, 80, 97, 1), // Color.fromRGBO(106, 115, 129, 1)
                      fontSize: 22,
                      fontWeight: FontWeight.w500)),
            ),
            Expanded(
                child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _renderActionWidget(),
                    _renderBreathWidget(),
                    _renderErrorWidget(),
                    _renderTargetWidget(),
                    SizedBox(
                      height: 40,
                    )

                    // Container(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //         Container(child:Text(
                    //           "你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好")),
                    //       Text("他好")
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ))
          ],
        )));
  }
}
