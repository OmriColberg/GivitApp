import 'package:cloud_firestore/cloud_firestore.dart';
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
  final dynamic contant;
  final List<String> contantList;
  final Size size;
  DeliveryAssign({
    required this.title,
    required this.body,
    required this.schedule,
    required this.isProduct,
    required this.contant,
    required this.isMain,
    required this.contantList,
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
        color: isProduct ? Colors.lightGreen[300] : Colors.deepPurple[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                isProduct ? Container() : Icon(Icons.airport_shuttle),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                isMain
                    ? Container()
                    : InkWell(
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                        ),
                        onTap: () {
                          contantList.remove(contant.id);
                          isProduct
                              ? db.updateGivitUserFields(
                                  {'Products': contantList})
                              : db.updateGivitUserFields(
                                  {'Transports': contantList});
                        },
                      )
              ],
            ),
            Text(
              body,
              style: TextStyle(fontSize: 16),
            ),
            isMain
                ? ElevatedButton(
                    onPressed: isProduct
                        ? () {
                            db.updateGivitUserFields({
                              "Products":
                                  FieldValue.arrayUnion(['${contant.id}'])
                            });
                          }
                        : () {
                            db.updateGivitUserFields({
                              "Transports":
                                  FieldValue.arrayUnion(['${contant.id}'])
                            });
                            db.updateTransportFields(contant.id, {
                              'Current Number Of Carriers':
                                  contant.currentNumOfCarriers + 1
                            });
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
                                  size: size,
                                  id: contant.id,
                                  products: contantList),
                            ),
                          );
                        },
                        child: Text('מצאתי'),
                      )
                    : Text(
                        'נרשמו ${contant.currentNumOfCarriers} מתוך  ${contant.totalNumOfCarriers} מובילים',
                        style: TextStyle(fontSize: 16),
                      ),
          ],
        ),
      ),
    );
  }
}
