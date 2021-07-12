import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/admin_feature/presentation/pages/add_product_page.dart';
import 'package:givit_app/admin_feature/presentation/pages/add_transport_page.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/models/transport.dart';
import 'package:givit_app/core/shared/assign_card_product.dart';
import 'package:givit_app/core/shared/assign_card_transport.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/services/database.dart';
import 'package:intl/intl.dart';
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
    return StreamBuilder<GivitUser>(
      stream: db.userData,
      builder: (context, snapshotGivitUser) {
        if (snapshotGivitUser.hasError) {
          return Text('Something went wrong');
        }

        if (snapshotGivitUser.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        GivitUser? givitUser = snapshotGivitUser.data;
        return StreamBuilder<QuerySnapshot>(
          stream: db.producstData,
          builder: (context, snapshotProduct) {
            if (snapshotProduct.hasError) {
              return Text('Something went wrong');
            }

            if (snapshotProduct.connectionState == ConnectionState.waiting) {
              return Loading();
            }

            List<Product?> _products =
                snapshotProduct.data!.docs.map((DocumentSnapshot document) {
              var snapshotData = document.data() as Map;
              Product product =
                  Product.productFromDocument(snapshotData, document.id);

              if (product.status == ProductStatus.waitingToBeDelivered)
                return product;
              else
                return Product();
            }).toList();
            _products.removeWhere((product) => product!.name == '');

            List<MultiSelectItem<Product>> _productToDelivery = _products
                .map(
                  (Product? product) =>
                      MultiSelectItem<Product>(product!, product.name),
                )
                .toList();
            return Container(
              color: Colors.blue[100],
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddProductPage(size: widget.size),
                            ),
                          ),
                        },
                        child: Text('הוספת מוצר חדש לחיפוש'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTransportPage(
                                size: widget.size,
                                productsToBeDelivered: _productToDelivery,
                              ),
                            ),
                          ),
                        },
                        child: Text('הוספת הובלה חדשה'),
                      ),
                    ],
                  ),
                  Text(
                    ':מוצרים זמינים להובלה',
                    style: TextStyle(fontSize: 16),
                  ),
                  SingleChildScrollView(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: db.transportsData,
                      builder: (context, snapshotTransport) {
                        if (snapshotTransport.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshotTransport.connectionState ==
                            ConnectionState.waiting) {
                          return Loading();
                        }

                        return Column(
                          children: [
                            [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _products.map((Product? product) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text(
                                          '${product!.name}\n${product.pickUpAddress}'),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              Text(
                                ':הובלות עתידיות',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                            snapshotTransport.data!.docs
                                .map((DocumentSnapshot document) {
                              var snapshotData = document.data() as Map;
                              // TODO: add if statement to show only by relevant status
                              Transport transport =
                                  Transport.transportFromDocument(
                                      snapshotData, document.id);
                              return createDeliveryAssignFromTransportSnapshot(
                                  transport,
                                  givitUser!.transports,
                                  widget.size);
                            }).toList(),
                          ].expand((element) => element).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

AssignCardProduct createDeliveryAssignFromProductSnapshot(
    Product product, List<String> products, Size size) {
  return AssignCardProduct(
    title: product.name,
    body: product.notes,
    schedule: 'לשיבוץ חיפוש',
    type: CardType.admin,
    product: product,
    personalProducts: products,
    size: size,
  );
}

AssignCardTransport createDeliveryAssignFromTransportSnapshot(
    Transport transport, List<String> transports, Size size) {
  String date;
  if (transport.datePickUp != null) {
    date =
        DateFormat('yyyy-MM-dd hh:mm').format(transport.datePickUp).toString();
  } else {
    date = '';
  }
  return AssignCardTransport(
    title: date + ' :הובלה ב',
    body: transport.notes,
    schedule: 'לשיבוץ הובלה',
    type: CardType.admin,
    transport: transport,
    personalTransport: transports,
    size: size,
  );
}
