import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:quit_product/common/config.dart';
import 'package:quit_product/common/widgets/keep_alive_widget.dart';
import 'package:quit_product/models/illustrations.dart';
import 'package:quit_product/pages/home/home_state.dart';
import 'package:quit_product/pages/tabs/main/main_controller.dart';
import 'package:quit_product/pages/tabs/main/main_page.dart';
import 'package:quit_product/routes/app_routes.dart';

class HomeController extends GetxController{
  final state = HomeState();
  bool isShowFilterView = false;

   int selectIndex = 0 ;

  PageController pageConTroller = PageController(initialPage: 0);
  late List<Widget> pageViews;
  @override
  void onInit(){
    super.onInit();
  }



    @override
  void onReady(){
    super.onReady();
  }
  

  void refreshTargets() {
    print("-------------)");

    //从数据库中读取数据，刷新页面

    state.mainController.updateData();
  }
    void onPushTargetSettingPageAction() {
    //不使用命名路由跳转，则不应该使用binding
    // navigator!.push(
    //   MaterialWithModalsPageRoute(builder: (context){
    //     return TargetPage();
    //   }, fullscreenDialog: true)
    // );

    Get.toNamed(Routes.TARGET);

    // Get.toNamed(Routes.TARGETSELECT);
  }
    void hideFilterView() {
    isShowFilterView = false;
    update(["filterView"]);
  }
    void updateFilterType(FilterType type) {
    state.mainController.updateFilterType(type);
  }
  void showFilterView() {
    isShowFilterView = true;

    update(["filterView"]);
  }

}