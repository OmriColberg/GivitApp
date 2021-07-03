import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/services/database.dart';
import 'package:provider/provider.dart';

class DeliveryAssign extends StatelessWidget {
  final String title;
  final String schedule;
  final String body;
  final bool isProduct;
  final bool isMain;
  final String id;
  final List<String> products;
  DeliveryAssign({
    required this.title,
    required this.body,
    required this.schedule,
    required this.isProduct,
    required this.id,
    required this.isMain,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final GivitUser givitUser = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: givitUser.uid);
    return Center(
      child: Card(
        color: isProduct ? Colors.lightGreen[100] : Colors.purple[100],
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.airport_shuttle),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Text(body),
            isMain
                ? ElevatedButton(
                    onPressed: isProduct
                        ? () {
                            db.addProductToGivitUser(id);
                          }
                        : () {},
                    child: Text(schedule),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      db.deleteProductFromProductList(id);
                      products.remove(id);
                      db.deleteProductFromUserList(id, products);
                    },
                    child: Text('מצאתי'),
                  )
          ],
        ),
      ),
    );
  }
}
