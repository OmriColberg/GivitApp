import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/admin_feature/presentation/pages/add_product_page.dart';
import 'package:givit_app/admin_feature/presentation/pages/add_product_warehouse_page.dart';
import 'package:givit_app/admin_feature/presentation/pages/add_transport_page.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/models/transport.dart';
import 'package:givit_app/core/shared/assign_card_product.dart';
import 'package:givit_app/core/shared/assign_card_transport.dart';
import 'package:givit_app/core/shared/constant.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/core/shared/product_found_form.dart';
import 'package:givit_app/services/database.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

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
      stream: db.givitUserData,
      builder: (context, snapshotGivitUser) {
        if (snapshotGivitUser.hasError) {
          return Text(snapshotGivitUser.error.toString() +
              'אירעה תקלה, נא לפנות למנהלים');
        }

        if (snapshotGivitUser.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        GivitUser? givitUser = snapshotGivitUser.data;
        return StreamBuilder<QuerySnapshot>(
          stream: db.producstData,
          builder: (context, snapshotProduct) {
            if (snapshotProduct.hasError) {
              return Text(snapshotProduct.error.toString() +
                  'אירעה תקלה, נא לפנות למנהלים');
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
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
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
                        ElevatedButton(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddProductWarehousePage(
                                  size: widget.size,
                                ),
                              ),
                            ),
                          },
                          child: Text('הוספת מוצר שקיים במחסן'),
                        ),
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
                    StreamBuilder<QuerySnapshot>(
                      stream: db.transportsData,
                      builder: (context, snapshotTransport) {
                        if (snapshotTransport.hasError) {
                          return Text(snapshotTransport.error.toString() +
                              'אירעה תקלה, נא לפנות למנהלים');
                        }

                        if (snapshotTransport.connectionState ==
                            ConnectionState.waiting) {
                          return Loading();
                        }

                        return Container(
                          child: Column(
                            children: [
                              [
                                Wrap(
                                  children: _products.map((Product? product) {
                                    return Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 2),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (product != null) {
                                              showDialogHelper(
                                                  product, widget.size, db);
                                            }
                                          },
                                          child: Directionality(
                                            textDirection: ui.TextDirection.rtl,
                                            child: Text(
                                              '${product!.name}\n${product.pickUpAddress}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                          ),
                                        ));
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
                                Transport transport =
                                    Transport.transportFromDocument(
                                        snapshotData, document.id);
                                if (transport.status !=
                                        TransportStatus.carriedOut &&
                                    transport.status != TransportStatus.mock) {
                                  return createDeliveryAssignFromTransportSnapshot(
                                      transport,
                                      givitUser!.transports,
                                      widget.size);
                                } else {
                                  return Container();
                                }
                              }).toList(),
                            ].expand((element) => element).toList(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showDialogHelper(Product product, Size size, DatabaseService db) {
    String length = product.length != 0
        ? "\nאורך המוצר בס''מ: " + product.length.toString()
        : '';
    String width = product.width != 0
        ? "\nרוחב המוצר בס''מ: " + product.width.toString()
        : '';
    String weight = product.weight != 0
        ? "\nמשקל המוצר בקילוגרמים: " + product.weight.toString()
        : '';
    String body = "שם הבעלים: " +
        product.ownerName +
        "\nמספר טלפון: " +
        product.ownerPhoneNumber +
        "\nכתוב לאיסוף: " +
        product.pickUpAddress +
        "\nזמן לאיסוף מוצר: " +
        product.timeForPickUp +
        "\nמצב המוצר: " +
        Product.hebrewFromEnum(product.state) +
        length +
        width +
        weight +
        "\nהערות: " +
        product.notes;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: size.height * 0.5,
          child: AlertDialog(
            title: Text(body),
            content: Column(
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(product.productPictureURL),
                    ),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Reference reference;
                        String productId = product.id;
                        Navigator.of(context).pop();
                        reference = db.storage
                            .ref()
                            .child('Products pictures/$productId');
                        reference.delete().then((_) => print(
                            'Successfully deleted Products Picture/$productId storage item'));
                        await db.deleteProductFromProductList(product.id);
                      },
                      child: Text('למחיקה'),
                    ),
                    SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductFoundForm(
                              size: size,
                              product: product,
                              products: [],
                              length: product.length,
                              ownerName: product.ownerName,
                              productImagePath: product.productPictureURL,
                              state: product.state,
                              weigth: product.weight,
                              width: product.width,
                              notes: product.notes,
                              ownerPhoneNumber: product.ownerPhoneNumber,
                              pickUpAddress: product.pickUpAddress,
                              timeForPickUp: product.timeForPickUp,
                              isUpdate: true,
                              pickedImage: product.productPictureURL !=
                                  defaultFurnitureUrl,
                            ),
                          ),
                        );
                      },
                      child: Text('לעריכה'),
                    ),
                    SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("לחזרה"),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
    isAdmin: true,
  );
}

AssignCardTransport createDeliveryAssignFromTransportSnapshot(
    Transport transport, List<String> transports, Size size) {
  String date =
      DateFormat('yyyy-MM-dd HH:mm').format(transport.datePickUp).toString();
  return AssignCardTransport(
    title: date + ' :הובלה ב' + '\n' + ' יוצאת מ: ' + transport.pickUpAddress,
    body: "הערות: " + transport.notes,
    schedule: 'לשיבוץ הובלה',
    type: CardType.admin,
    transport: transport,
    personalTransport: transports,
    size: size,
    isAdmin: true,
  );
}
