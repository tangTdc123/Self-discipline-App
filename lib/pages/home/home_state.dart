
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quit_product/common/widgets/keep_alive_widget.dart';
import 'package:quit_product/pages/tabs/main/main_controller.dart';
import 'package:quit_product/pages/tabs/main/main_page.dart';

enum HomePageTab { Tab_Main, Tab_Exercise }

class HomeState {
  late PageController pageController;
  late List<Widget> pageViews;

  late HomePageTab homePageTab;

  var showMask = false.obs;

  int selectedIndex = 0;

  MainController mainController = Get.find<MainController>();

  HomeState() {
    homePageTab = HomePageTab.Tab_Main;

    pageController = PageController(initialPage: 0);

    pageViews = [
      KeepAliveWidget(MainPage()),
      KeepAliveWidget(Container()),
    ];
  }
}
