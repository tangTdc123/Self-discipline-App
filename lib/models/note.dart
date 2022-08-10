
import 'package:quit_product/utils/date_time.dart';
import 'package:quit_product/utils/object_util.dart';

class Note {
  int? id;
  int? targetId;
  String? note;
  DateTime? createTime;

  Note clone() {
    return Note()
      ..id = id
      ..targetId = targetId
      ..note = note
      ..createTime = createTime;
  }

  static Note? noteFromMap(Map<String, dynamic> map) {
    if (ObjectUtil.isEmptyMap(map)) return null;

    String createTimeString = map["n_createtime"];
    DateTime? createTime = stringToDateTime(createTimeString);

    return Note()
      ..id = map["id"] as int
      ..targetId = map["target_id"] as int
      ..note = map["note"] as String
      ..createTime = createTime;
  }
}
