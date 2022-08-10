class Jounery {
  DateTime? createTime;
  String? text;

  Jounery clone() {
    return Jounery()
      ..text = text
      ..createTime = createTime;
  }
}
