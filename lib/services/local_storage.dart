import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService extends GetxService {
  Future<SharedPreferences> init() async {
            print("-- SharedPreferences.getInstance)");
    return await SharedPreferences.getInstance();
  }
}