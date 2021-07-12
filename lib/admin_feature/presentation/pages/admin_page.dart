import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/admin_feature/presentation/pages/add_product_page.dart';
import 'package:givit_app/admin_feature/presentation/pages/add_transport_page.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/services/database.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  AdminPage({required this.size});
  final Size size;
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    GivitUser user = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: user.uid);
    return StreamBuilder<QuerySnapshot>(
      stream: db.producstData,
      builder: (context, snapshotProduct) {
        if (snapshotProduct.hasError) {
          return Text('Something went wrong');
        }

        if (snapshotProduct.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        List<MultiSelectItem<Product?>> _products = snapshotProduct.data!.docs
            .map((DocumentSnapshot document) {
              var snapshotData = document.data() as Map;
              Product product =
                  Product.productFromDocument(snapshotData, document.id);

              if (product.status == ProductStatus.waitingToBeDelivered)
                return product;
              else
                return Product();
            })
            .toList()
            .map(
              (Product? product) =>
                  MultiSelectItem<Product>(product!, product.name),
            )
            .toList();
        _products.removeWhere((product) => product.value!.name == '');

        return Container(
          color: Colors.blue[100],
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProductPage(size: widget.size),
                    ),
                  ),
                },
                child: Text('הוספת מוצר חדש לחיפוש'),
              ),
              ElevatedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTransportPage(
                        size: widget.size,
                        productsToBeDelivered: _products,
                      ),
                    ),
                  ),
                },
                child: Text('הוספת הובלה חדשה'),
              ),
            ],
          ),
        );
      },
    );
  }
}
