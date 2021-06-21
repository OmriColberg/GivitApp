import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/services/database.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ProductPage();
  }
}

class _ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GivitUser givitUser = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: givitUser.uid);
    return StreamBuilder<QuerySnapshot>(
        stream: db.productsUser,
        builder: (context, snapshotProduct) {
          if (snapshotProduct.hasError) {
            return Text('Something went wrong');
          }

          if (snapshotProduct.connectionState == ConnectionState.waiting) {
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
                children: snapshotProduct.data.docs.map(
                  (DocumentSnapshot document) {
                    var snapshotdata = document.data() as Map;
                    Product product =
                        Product.productFromDocument(snapshotdata, document.id);
                    print(product.name);
                    return Container(
                      child: Text(product.name),
                    );
                  },
                ).toList(),
              ),
            ),
          );
        });
  }
}
