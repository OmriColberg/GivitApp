import 'package:flutter/material.dart';

class DeliveryAssign extends StatelessWidget {
  final String title;
  final String schedule;
  final String body;
  DeliveryAssign(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.airport_shuttle),
                Text(
                  title ?? 'דרושים',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Text(body ?? 'ללא פירוט נוסף'),
            ElevatedButton(
              onPressed: () {},
              child: Text(schedule ?? 'לשיבוץ'),
            ),
          ],
        ),
      ),
    );
  }
}
