import 'dart:convert';

import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  static final String policyCacheKey = "Policy";

  static Future<bool> userHasAgreePolicy() async {
    var prefs = Get.find<SharedPreferences>();

    if (prefs.get(policyCacheKey) == null) {
      Map map = {};
      prefs.setString(policyCacheKey, json.encode(map));
    }

    //当前版本号
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String currentVersion = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    String? mapString = prefs.getString(policyCacheKey);

    if (mapString == null) {
      return false;
    }

    Map map = json.decode(mapString);

    return map[buildNumber] == null ? false : map[buildNumber];
  }

  static void saveUserPolicyCache() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String currentVersion = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    var prefs = Get.find<SharedPreferences>();

    String? mapString = prefs.getString(policyCacheKey);

    if (mapString != null) {
      Map map = json.decode(mapString);

      map.putIfAbsent(buildNumber, () => true);

      prefs.setString(policyCacheKey, json.encode(map));
    }
  }
}
