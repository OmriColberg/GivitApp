import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/core/models/product.dart';
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
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
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
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    var snapshotData = document.data() as Map;
                    Product product =
                        Product.productFromDocument(snapshotData, document.id);
                    return createDeliveryAssignFromProductSnapshot(product);
                  }).toList()),
            ),
          );
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
