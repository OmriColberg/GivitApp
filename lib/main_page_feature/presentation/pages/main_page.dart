import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/models/transport.dart';
import 'package:givit_app/core/shared/assign_card_transport.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/core/shared/assign_card_product.dart';
import 'package:givit_app/services/database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  final Size size;
  MainPage({required this.size});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    GivitUser user = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: user.uid);
    return StreamBuilder<GivitUser>(
      stream: db.userData,
      builder: (context, snapshotGivitUser) {
        if (!snapshotGivitUser.hasData) {
          return Loading();
        }

        GivitUser? givitUser = snapshotGivitUser.data;
        return StreamBuilder<QuerySnapshot>(
          stream: db.producstData,
          builder: (context, snapshotProduct) {
            if (snapshotProduct.hasError) {
              return Text('אירעה תקלה, נא לפנות למנהלים');
            }

            if (snapshotProduct.connectionState == ConnectionState.waiting) {
              return Loading();
            }

            return StreamBuilder<QuerySnapshot>(
              stream: db.transportsData,
              builder: (context, snapshotTransport) {
                if (snapshotTransport.hasError) {
                  return Text('אירעה תקלה, נא לפנות למנהלים');
                }

                if (snapshotTransport.connectionState ==
                    ConnectionState.waiting) {
                  return Loading();
                }

                return Container(
                  color: Colors.blue[100],
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        snapshotProduct.data!.docs
                            .map((DocumentSnapshot document) {
                          var snapshotData = document.data() as Map;
                          Product product = Product.productFromDocument(
                              snapshotData, document.id);
                          if (product.status == ProductStatus.searching &&
                              !(givitUser!.products.contains(product.id)))
                            return createDeliveryAssignFromProductSnapshot(
                                product, widget.size);
                          else
                            return Container();
                        }).toList(),
                        snapshotTransport.data!.docs
                            .map((DocumentSnapshot document) {
                          var snapshotData = document.data() as Map;
                          Transport transport = Transport.transportFromDocument(
                              snapshotData, document.id);
                          if (transport.status ==
                                  TransportStatus.waitingForVolunteers &&
                              !(givitUser!.transports.contains(transport.id))) {
                            return createDeliveryAssignFromTransportSnapshot(
                                transport, widget.size);
                          } else {
                            return Container();
                          }
                        }).toList(),
                      ].expand((element) => element).toList(),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

AssignCardProduct createDeliveryAssignFromProductSnapshot(
    Product product, Size size) {
  return AssignCardProduct(
    title: product.name,
    body: product.notes,
    schedule: 'לשיבוץ חיפוש',
    type: CardType.main,
    product: product,
    personalProducts: [],
    size: size,
  );
}

AssignCardTransport createDeliveryAssignFromTransportSnapshot(
    Transport transport, Size size) {
  String date =
      DateFormat('yyyy-MM-dd hh:mm').format(transport.datePickUp).toString();

  return AssignCardTransport(
    title: date + ' :הובלה ב' + '\n' + transport.pickUpAddress + ' :יוצאת מ',
    body: transport.notes + " :הערות",
    schedule: 'לשיבוץ הובלה',
    type: CardType.main,
    transport: transport,
    personalTransport: [],
    size: size,
  );
}
