import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/models/transport.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/main_page_feature/presentation/pages/assign_card.dart';
import 'package:givit_app/services/database.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MainPage();
  }
}

class _MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService();
    return StreamBuilder<QuerySnapshot>(
        stream: db.producstData,
        builder: (context, snapshotProduct) {
          if (snapshotProduct.hasError) {
            return Text('Something went wrong');
          }

          if (snapshotProduct.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          return StreamBuilder<QuerySnapshot>(
              stream: db.transportsData,
              builder: (context, snapshotTransport) {
                if (snapshotTransport.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshotTransport.connectionState ==
                    ConnectionState.waiting) {
                  return Loading();
                }

                return Container(
                  color: Colors.blue[100],
                  height: 400.0,
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        snapshotProduct.data.docs
                            .map((DocumentSnapshot document) {
                          var snapshotData = document.data() as Map;
                          Product product = Product.productFromDocument(
                              snapshotData, document.id);
                          return createDeliveryAssignFromProductSnapshot(
                              product);
                        }).toList(),
                        snapshotTransport.data.docs
                            .map((DocumentSnapshot document) {
                          var snapshotData = document.data() as Map;
                          Transport transport = Transport.transportFromDocument(
                              snapshotData, document.id);
                          return createDeliveryAssignFromTransportSnapshot(
                              transport);
                        }).toList(),
                      ].expand((element) => element).toList(),
                    ),
                  ),
                );
              });
        });
  }
}

DeliveryAssign createDeliveryAssignFromProductSnapshot(Product product) {
  return DeliveryAssign(
    title: product.name,
    body: product.notes,
    schedule: 'לשיבוץ חיפוש',
  );
}

DeliveryAssign createDeliveryAssignFromTransportSnapshot(Transport transport) {
  return DeliveryAssign(
    title: transport.destinationAddress,
    body: transport.notes,
    schedule: 'לשיבוץ חיפוש',
  );
}
