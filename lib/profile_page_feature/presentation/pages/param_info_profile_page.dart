import 'package:flutter/material.dart';

class ParamInfoPersonalArea extends StatelessWidget {
  const ParamInfoPersonalArea(
      {required this.controller,
      required this.paramInfo,
      required bool status,
      required this.obscure})
      : _status = status;

  final TextEditingController controller;
  final String? paramInfo;
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
                obscureText: obscure,
                controller: controller,
                decoration: InputDecoration(hintText: obscure ? '' : paramInfo),
                enabled: !_status,
                autofocus: !_status,
              ),
            ),
          ],
        ));
  }
}
