import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:quit_product/routes/app_routes.dart';
import 'package:quit_product/utils/common.dart';

import 'common/language.dart';



Widget createApp() {
  return OKToast(
      dismissOtherOnShow: true, //全局设置隐藏之前的属性,这里设置后,每次当你显示新的 toast 时,旧的就会被关闭
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: Language(),
        locale: getCurrentLocale(),
        fallbackLocale: Locale('en', 'US'),
        builder: EasyLoading.init(),
        theme: ThemeData(
            primaryColor: Colors.white,
            fontFamily: getFontFamilyByLanguage(),
            // textButtonTheme: TextButtonThemeData(
            //     style: ButtonStyle(textStyle: MaterialStateProperty.all(
            //         //定义文本的样式 这里设置的颜色是不起作用的
            //         TextStyle(fontFamily: _getFontFamilyByLanguage()))))
                    ),
        initialRoute: Routes.SPLASH,
        getPages: AppPages.pages,
//     onGenerateRoute: (RouteSettings settings){
// return GetPageRoute(settings: settings);
//     },
      ));
}
