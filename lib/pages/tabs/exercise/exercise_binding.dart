
import 'package:get/get.dart';
import 'package:quit_product/pages/tabs/exercise/exercise_controller.dart';

class ExerciseBinding extends Bindings {
  @override
  void dependencies() {
print(Get.arguments);

String? tag;
if (Get.arguments != null){
  tag = Get.arguments["from"];
}
    Get.put<ExerciseController>(ExerciseController(), tag: tag);
  }
}
