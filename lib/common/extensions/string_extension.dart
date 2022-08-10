extension StringExt on String{
  String addZero(){
    int num =  int.parse(this);
    if (num < 10) return "0$num";
    return this;
  }
}