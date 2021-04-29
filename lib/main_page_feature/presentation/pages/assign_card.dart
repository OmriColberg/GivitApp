import 'package:flutter/material.dart';

class DeliveryAssign extends StatelessWidget {
  final String title;
  final String schedule;
  final String body;
  const DeliveryAssign(
      {Key key,
      @required this.title,
      /* @required*/ this.body,
      @required this.schedule})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(Icons.airport_shuttle),
                SizedBox(
                  width: 200,
                ),
                Text(
                  title ?? 'דרושים',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Text(body ?? 'כאן יהיה פירוט יתר אוטומטי'),
            TextButton(
              child: Text(schedule ?? 'לשיבוץ'),
              onPressed: () {/* ... */},
            ),
          ],
        ),
      ),
    );
  }
}
