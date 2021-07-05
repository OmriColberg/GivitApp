import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/profile_page_feature/presentation/pages/product_found_form.dart';
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
  final Size size;
  DeliveryAssign({
    required this.title,
    required this.body,
    required this.schedule,
    required this.isProduct,
    required this.id,
    required this.isMain,
    required this.products,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final GivitUser givitUser = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: givitUser.uid);
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(4),
        ),
        color: isProduct ? Colors.lightGreen[300] : Colors.red[300],
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
                        : () {
                            db.addTransportToGivitUser(id);
                          },
                    child: Text(schedule),
                  )
                : isProduct
                    ? ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductFoundForm(
                                  size: size, id: id, products: products),
                            ),
                          );
                        },
                        child: Text('מצאתי'),
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
