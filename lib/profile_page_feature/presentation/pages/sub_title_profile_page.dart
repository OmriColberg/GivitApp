import 'package:flutter/material.dart';

class SubTitlePersonalArea extends StatelessWidget {
  final String title;
  SubTitlePersonalArea({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ));
  }
}
