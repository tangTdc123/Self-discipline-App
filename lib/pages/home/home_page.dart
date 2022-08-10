import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quit_product/common/config.dart';
import 'package:quit_product/pages/home/home_controller.dart';
import 'package:quit_product/pages/tabs/exercise/exercise_page.dart';
import 'package:quit_product/pages/tabs/main/main_controller.dart';
import 'package:quit_product/pages/tabs/main/main_page.dart';
import 'package:quit_product/routes/app_routes.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double bottomTabViewHeight = 60.0;

  final HomeController homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return 
        Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Stack(
          children: [
            Positioned(
                child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: homeController.pageConTroller,
              children: [
                MainPage(),
                ExercisePage(),
              ],
            )),
            GetBuilder<HomeController>(
                            id: "filterView",
                            builder: (controller) {
                              if (homeController.isShowFilterView == false)
                                return Container();
                              return _FilterView(
                                  homeController: controller,
                                  callBack: (selectedType) {
                                    controller.updateFilterType(selectedType);
                                  });
                            })
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: homeController.selectIndex,
          onTap: (value) => {
            setState(() {
              homeController.pageConTroller.animateToPage(value,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease);
              homeController.selectIndex = value;
            })
          },
          items: [
            BottomNavigationBarItem(
                title: new Container(),
                icon: SvgPicture.asset(
                  'assets/icons/common/menu.svg',
                  color: homeController.selectIndex == 0
                      ? commonGreenColor
                      : Colors.grey,
                )),
            BottomNavigationBarItem(
                title: new Container(),
                icon: SvgPicture.asset(
                  'assets/icons/common/exercise.svg',
                  color: homeController.selectIndex == 1
                      ? commonGreenColor
                      : Colors.grey,
                )),
          ],
        ),
        );

      
  }
}
class _FilterView extends StatefulWidget {
  _FilterView({required this.homeController, required this.callBack});
  final HomeController homeController;
  final Function(FilterType selectedType) callBack;

  @override
  State<StatefulWidget> createState() {
    return _FilterViewState();
  }
}

class FilterObj {
  FilterObj(this.name, this.icon);

  String name;
  String icon;
}
class _FilterViewState extends State<_FilterView>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  late CurvedAnimation curve;
  double top = -500;

  late FilterType filterType;
  late int fileterIndex;

  @override
  void initState() {
    super.initState();

    MainController mainController = Get.find<MainController>();
    filterType = mainController.currentFilterType;

    switch (filterType) {
      case FilterType.all:
        fileterIndex = 0;
        break;
      case FilterType.processing:
        fileterIndex = 1;
        break;
      case FilterType.completed:
        fileterIndex = 2;
        break;
      case FilterType.giveup:
        fileterIndex = 3;
        break;
      default:
        break;
    }

    animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    curve = new CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);

    animation = Tween<double>(begin: -500, end: 0).animate(curve)
      ..addListener(() {
        setState(() {
          top = animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          widget.homeController.hideFilterView();
        }
      });

    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  Widget _renderFilterView(int selectedIndex,
      {required Function(int index) callBack}) {
    List<FilterObj> objs = [
      FilterObj('all'.tr, "assets/icons/common/disappointed-face.svg"),
      FilterObj('progressing'.tr,
          "assets/icons/common/beaming-face-with-smiling-eyes.svg"),
      FilterObj('completed'.tr,
          "assets/icons/common/beaming-face-with-smiling-eyes.svg"),
      FilterObj('giveup'.tr, "assets/icons/common/disappointed-face.svg")
    ];

    List<Widget> widgets = [];

    for (int i = 0; i < objs.length; i++) {
      FilterObj obj = objs[i];
      widgets.add(GestureDetector(
        onTap: () {
          callBack(i);
        },
        child: Container(
            height: 50,
            color: Colors.white,
            child: Stack(
              fit: StackFit.expand,
              children: [
                i < objs.length - 1
                    ? Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 1,
                          color: Color.fromRGBO(230, 230, 230, 1),
                        ))
                    : Container(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(obj.icon, width: 28, height: 28),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(obj.name,
                          style: TextStyle(
                              color: textBlackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400)),
                    ),
                    Expanded(child: Container()),
                    i == selectedIndex
                        ? Container(
                            margin: EdgeInsets.only(right: 10),
                            child: SvgPicture.asset(
                                "assets/icons/common/check.svg",
                                color: Colors.green,
                                width: 25,
                                height: 25),
                          )
                        : Container()
                  ],
                )
              ],
            )),
      ));
    }

    return Container(
      // height: 260,
      padding: EdgeInsets.only(
          top: MediaQuery.of(Get.context!).padding.top,
          left: 30,
          right: 30,
          bottom: 6),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: GestureDetector(
            onTap: () {
              if (animationController.isAnimating) return;

              animationController.reverse();

              FilterType? filterType;
              switch (fileterIndex) {
                case 0:
                  filterType = FilterType.all;
                  break;
                case 1:
                  filterType = FilterType.processing;
                  break;
                case 2:
                  filterType = FilterType.completed;
                  break;
                case 3:
                  filterType = FilterType.giveup;
                  break;
                default:
              }

              widget.callBack(filterType!);
            },
            child: Container(
              color: Colors.black45.withOpacity(0.3),
              child: Stack(
                children: [
                  Positioned(
                      left: 0,
                      right: 0,
                      top: top,
                      child: _renderFilterView(fileterIndex, callBack: (index) {
                        setState(() {
                          fileterIndex = index;
                        });
                      }))
                ],
              ),
            )));
  }
}
