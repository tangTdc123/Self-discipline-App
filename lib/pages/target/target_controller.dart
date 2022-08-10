import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:quit_product/common/config.dart';
import 'package:quit_product/models/target.dart';

class TargetController extends GetxController{
  late Target target;
   
  List<Target> targets = List.from(defaultTargets);

  @override
  void OnInit(){
    super.onInit();
  }

    @override
  void onReady(){
    super.onReady();
  }

    void updateTarget(Target updateTarget) {
    target = updateTarget;

    update(['all', 'appbar']);
  }

  
}