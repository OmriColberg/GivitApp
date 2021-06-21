import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/services/database.dart';
import 'package:provider/provider.dart';

class DeliveryAssign extends StatelessWidget {
  final String title;
  final String schedule;
  final String body;
  final bool isProduct;
  final String id;
  DeliveryAssign(
      {Key key,
      @required this.title,
      /* @required*/ this.body,
      @required this.schedule,
      @required this.isProduct,
      @required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GivitUser givitUser = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: givitUser.uid);
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
              onPressed: isProduct
                  ? () {
                      db.addProductToGivitUser(id);
                    }
                  : () {},
              child: Text(schedule ?? 'לשיבוץ'),
            ),
          ],
        ),
      ),
    );
  }
}
