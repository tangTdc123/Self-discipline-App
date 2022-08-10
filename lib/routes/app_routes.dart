import 'package:get/get.dart';
import 'package:quit_product/pages/help/help_binging.dart';
import 'package:quit_product/pages/help/help_page.dart';
import 'package:quit_product/pages/home/home_binding.dart';
import 'package:quit_product/pages/home/home_page.dart';
import 'package:quit_product/pages/splash/splash_binding.dart';
import 'package:quit_product/pages/splash/splash_page.dart';
import 'package:quit_product/pages/tabs/exercise/exercise_binding.dart';
import 'package:quit_product/pages/tabs/exercise/exercise_page.dart';
import 'package:quit_product/pages/target/target_binding.dart';
import 'package:quit_product/pages/target/target_page.dart';
import 'package:quit_product/pages/task_detail/target_detail_binding.dart';
import 'package:quit_product/pages/task_detail/target_detail_page.dart';

abstract class AppPages{
  static final pages=[
    GetPage(name:Routes.SPLASH,page: ()=> SplashPage(),binding: SplashBinding()),
    GetPage(name:Routes.HOME,page: ()=> HomePage(),binding: HomeBinding()),
    GetPage(name:Routes.TARGET,page: ()=> TargetPage(),binding: TargetBinding()),
    GetPage(
        name: Routes.TARGETDETAIL,
        page: () => TargetDetailPage(),
        binding: TargetDetailBinding(),
        fullscreenDialog: false),
    GetPage(
        name: Routes.EXERCISE,
        page: () => ExercisePage(),
        binding: ExerciseBinding()),
    GetPage(
        name: Routes.HELP,
        page: () => HelpPage(),
        binding: HelpBinding(),
        fullscreenDialog: true)


  ];
}

abstract class Routes{
  static const INITIAL='/';
  static const SPLASH="/splash";
  static const HOME="/home";
  static const TARGET="/target";  
  static const TARGETDETAIL = '/targetDetail';
  static const EXERCISE = '/exercise';
  static const HELP = '/help';



}