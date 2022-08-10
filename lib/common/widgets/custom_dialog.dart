import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quit_product/common/extensions/string_extension.dart';

class NotificationTimePickerWidget extends StatefulWidget {
  NotificationTimePickerWidget({this.selectTimeCallBack, this.bgColor});

  final Color? bgColor;

  final Function(String? selectedHour, String? selectedMins)?
      selectTimeCallBack;

  @override
  State<StatefulWidget> createState() {
    return NotificationTimePickerWidgetState();
  }
}

class NotificationTimePickerWidgetState
    extends State<NotificationTimePickerWidget> {
  final List<String> hours = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23'
  ];
  final List<String> minutes = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '49',
    '50',
    '51',
    '52',
    '53',
    '54',
    '55',
    '56',
    '57',
    '58',
    '59'
  ];

  bool hoursPickerIsScroll = false;
  bool minutesPickerIsScroll = false;

  FixedExtentScrollController? hoursScrollController;
  FixedExtentScrollController? minutesScrollController;

  String? selectedHour;
  String? selectedMinutes;

  @override
  void initState() {
    super.initState();

    hoursScrollController = FixedExtentScrollController(initialItem: 21);
    minutesScrollController = FixedExtentScrollController(initialItem: 30);

    selectedHour = "21";
    selectedMinutes = "30";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Material(
            type: MaterialType.transparency,
            child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 140,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: Container(
                      width: 90,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(232, 233, 234, 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: NotificationListener(
                                  onNotification: (scrollNotification) {
                                    if (scrollNotification
                                        is ScrollStartNotification) {
                                      print("**************");
                                      hoursPickerIsScroll = true;
                                    } else if (scrollNotification
                                        is ScrollEndNotification) {
                                      print("================");
                                      hoursPickerIsScroll = false;
                                    }
                                    return true;
                                  },
                                  child: CupertinoPicker(
                                    // backgroundColor: Colors.white,
                                    selectionOverlay:
                                        CupertinoPickerDefaultSelectionOverlay(
                                            background: Colors.transparent),
                                    itemExtent: 40,
                                    diameterRatio: 4,
                                    offAxisFraction: 0,
                                    squeeze: 1.0,
                                    looping: true,
                                    onSelectedItemChanged: (index) {
                                      selectedHour = hours[index];
                                    },
                                    // childCount: hours.length,
                                    scrollController: hoursScrollController,

                                    // itemBuilder: (context, index) {
                                    //   return Container(
                                    //       padding: EdgeInsets.only(right: 4),
                                    //       alignment: Alignment.centerRight,
                                    //       child: Text(
                                    //         hours[index].addZero(),
                                    //         textAlign: TextAlign.right,
                                    //         style: TextStyle(
                                    //             fontWeight: FontWeight.w600,
                                    //             color: widget.bgColor),
                                    //       ));
                                    // },
                                    children: hours
                                        .map((e) => Container(
                                            padding: EdgeInsets.only(right: 4),
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              e.addZero(),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: widget.bgColor),
                                            )))
                                        .toList(),
                                  ))),
                          Container(
                            alignment: Alignment.center,
                            // margin: EdgeInsets.only(left: 5, right: 5),
                            child: Text(":",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: widget.bgColor)),
                          ),
                          Expanded(
                              child: NotificationListener(
                                  onNotification: (scrollNotification) {
                                    if (scrollNotification
                                        is ScrollStartNotification) {
                                      print("**************");
                                      minutesPickerIsScroll = true;
                                    } else if (scrollNotification
                                        is ScrollEndNotification) {
                                      print("================");
                                      minutesPickerIsScroll = false;
                                    }
                                    return true;
                                  },
                                  child: CupertinoPicker(
                                    // backgroundColor: Colors.white,
                                    selectionOverlay:
                                        CupertinoPickerDefaultSelectionOverlay(
                                            background: Colors.transparent),
                                    itemExtent: 40,
                                    diameterRatio: 4,
                                    offAxisFraction: 0,
                                    squeeze: 1.0,
                                    looping: true,
                                    onSelectedItemChanged: (index) {
                                      print("+++++++++++++");
                                      selectedMinutes = minutes[index];
                                    },
                                    // childCount: minutes.length,
                                    scrollController: minutesScrollController,
                                    // itemBuilder: (context, index) {
                                    //   return Container(
                                    //       padding: EdgeInsets.only(left: 4),
                                    //       alignment: Alignment.centerLeft,
                                    //       child: Text(minutes[index].addZero(),
                                    //           textAlign: TextAlign.left,
                                    //           style: TextStyle(
                                    //               fontWeight: FontWeight.w600,
                                    //               color: widget.bgColor)));
                                    // },
                                    children: minutes
                                        .map((e) => Container(
                                            padding: EdgeInsets.only(left: 4),
                                            alignment: Alignment.centerLeft,
                                            child: Text(e.addZero(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: widget.bgColor))))
                                        .toList(),
                                  )))
                        ],
                      )),
                ))),
        onWillPop: () async {
          print("-------");

          if (!hoursPickerIsScroll && !minutesPickerIsScroll) {
            widget.selectTimeCallBack?.call(selectedHour, selectedMinutes);
          }
          return true;
        });
  }
}

void showNotificationTimePickerDialog(BuildContext context,
    {Function(String? selectedHour, String? selectedMins)? selectTimeCallBack,
    Color? bgColor}) {
  showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext ctx) {
        return NotificationTimePickerWidget(
            selectTimeCallBack: selectTimeCallBack, bgColor: bgColor);
      });
}
