
import 'package:get/get.dart';
import 'package:quit_product/common/config.dart';
import 'package:quit_product/models/exercise.dart';

class ExerciseController extends GetxController {
  List<Exercise> exerciseList = List.from(exercises);

   String? from;

  @override
  void onInit() {
    super.onInit();
    print("onInit");

    if (Get.arguments != null) {
      from = Get.arguments["from"];
      print(from);
    }

        print("Get.arguments");


  }

  @override
  void onReady() async {
    super.onReady();
  }
}
