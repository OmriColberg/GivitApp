import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/models/transport.dart';
import 'package:givit_app/core/shared/assign_card_product.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/profile_page_feature/presentation/pages/product_found_form.dart';
import 'package:givit_app/services/database.dart';
import 'package:provider/provider.dart';

class AssignCardTransport extends StatelessWidget {
  final String title;
  final String schedule;
  final String body;
  final Transport transport;
  final List<String> personalTransport;
  final Size size;
  final CardType type;
  AssignCardTransport({
    required this.title,
    required this.body,
    required this.schedule,
    required this.transport,
    required this.personalTransport,
    required this.size,
    required this.type,
  });
  var i = 0;

  @override
  Widget build(BuildContext context) {
    final GivitUser givitUser = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: givitUser.uid);
    return StreamBuilder<QuerySnapshot>(
        stream: db.producstData,
        builder: (context, snapshotProduct) {
          if (snapshotProduct.hasError) {
            return Text('Something went wrong');
          }

          if (snapshotProduct.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          return Center(
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(4),
              ),
              color: Colors.deepPurple[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      type == CardType.personal
                          ? InkWell(
                              child: Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                              ),
                              onTap: () {
                                personalTransport.remove(transport.id);
                                if (transport.currentNumOfCarriers ==
                                    transport.totalNumOfCarriers) {
                                  db.updateTransportFields(transport.id, {
                                    'Status Of Transport':
                                        "waitingForVolunteers"
                                  });
                                }
                                db.updateGivitUserFields(
                                    {'Transports': personalTransport});
                                db.updateTransportFields(transport.id, {
                                  'Current Number Of Carriers':
                                      transport.currentNumOfCarriers - 1,
                                  "Carriers":
                                      FieldValue.arrayRemove(['${db.uid}'])
                                });
                              },
                            )
                          : Container()
                    ],
                  ),
                  Text(
                    body,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  Column(
                    children: [
                      snapshotProduct.data!.docs
                          .map((DocumentSnapshot document) {
                        if (transport.products.contains(document.id)) {
                          var snapshotData = document.data() as Map;
                          Product product = Product.productFromDocument(
                              snapshotData, document.id);
                          if (transport.status.toString() !=
                              ProductStatus.searching.toString()) {
                            return Text(
                              "${++i}. " + product.name,
                              style: TextStyle(fontSize: 18),
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      }).toList(),
                      [
                        Text(
                          'נרשמו ${transport.currentNumOfCarriers} מתוך  ${transport.totalNumOfCarriers} מובילים',
                          style: TextStyle(fontSize: 16),
                        ),
                        type == CardType.main
                            ? (ElevatedButton(
                                onPressed: () {
                                  db.updateGivitUserFields({
                                    "Transports": FieldValue.arrayUnion(
                                        ['${transport.id}'])
                                  });
                                  db.updateTransportFields(transport.id, {
                                    'Status Of Transport':
                                        transport.currentNumOfCarriers + 1 ==
                                                transport.totalNumOfCarriers
                                            ? TransportStatus.waitingForDueDate
                                                .toString()
                                                .split('.')[1]
                                            : TransportStatus
                                                .waitingForVolunteers
                                                .toString()
                                                .split('.')[1],
                                    'Current Number Of Carriers':
                                        transport.currentNumOfCarriers + 1,
                                    "Carriers":
                                        FieldValue.arrayUnion(['${db.uid}'])
                                  });
                                },
                                child: Text(schedule),
                              ))
                            : type == CardType.personal
                                ? Text(
                                    "\"עם הרשמות להובלה גדולה מגיעה אחריות גדולה\"",
                                    style: TextStyle(fontSize: 14),
                                  )
                                : (transport.currentNumOfCarriers ==
                                        transport.totalNumOfCarriers
                                    ? ElevatedButton(
                                        onPressed: () {
                                          db.updateTransportFields(
                                              transport.id, {
                                            'Status Of Transport':
                                                TransportStatus.carriedOut
                                                    .toString()
                                                    .split('.')[1],
                                          });
                                        },
                                        child: Text("אישור ביצוע ההובלה"),
                                      )
                                    : Container())
                      ]
                    ].expand((element) => element).toList(),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
