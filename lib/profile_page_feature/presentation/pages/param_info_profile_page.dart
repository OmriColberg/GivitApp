import 'package:flutter/material.dart';

class ParamInfoPersonalArea extends StatelessWidget {
  const ParamInfoPersonalArea(
      {Key key,
      @required this.controller,
      @required this.paramInfo,
      @required bool status,
      this.obscure})
      : _status = status,
        super(key: key);

  final TextEditingController controller;
  final String paramInfo;
  final bool _status;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              child: TextField(
                obscureText: obscure ?? false,
                controller: controller,
                decoration:
                    InputDecoration(hintText: obscure != null ? '' : paramInfo),
                enabled: !_status,
                autofocus: !_status,
              ),
            ),
          ],
        ));
  }
}
