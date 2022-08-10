import 'package:get/get.dart';
import 'package:quit_product/pages/tabs/exercise/exercise_controller.dart';
import 'package:quit_product/pages/tabs/main/main_controller.dart';

import 'home_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => MainController());
    Get.lazyPut<ExerciseController>(() => ExerciseController());


  }
  
}

