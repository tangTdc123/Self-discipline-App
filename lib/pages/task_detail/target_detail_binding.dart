
import 'package:get/get.dart';
import 'package:quit_product/pages/task_detail/target_detail_controller.dart';

class Tags{
  static int tag = 0;
}

class TargetDetailBinding extends Bindings{
  @override
  void dependencies() {
    // String tag = "${++Tags.tag}";

    print(Get.arguments);

    Get.put<TargetDetailController>(TargetDetailController());
  }

}