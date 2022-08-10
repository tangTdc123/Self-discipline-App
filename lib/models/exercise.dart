class Exercise{
  String asset;
  String name;
  String? copyright;
  String? effect;
  List<String>? actions;
  List<String>? breaths;
  List<String>? errors;
  List<String>? targets;

  Exercise(this.asset, {required this.name, this.copyright, this.effect, this.actions, this.breaths, this.errors, this.targets});
}