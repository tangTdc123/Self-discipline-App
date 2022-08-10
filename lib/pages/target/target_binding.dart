import 'package:get/get.dart';
import 'package:quit_product/pages/target/target_controller.dart';

class TargetBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies 
    Get.lazyPut(() => TargetController());

  }
  
}