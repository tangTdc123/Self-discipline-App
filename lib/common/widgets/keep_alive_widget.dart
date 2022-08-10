import 'package:flutter/material.dart';

//页面状态保持
class KeepAliveWidget extends StatefulWidget {
  final Widget child;

  KeepAliveWidget(this.child);

  @override
  State<StatefulWidget> createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}