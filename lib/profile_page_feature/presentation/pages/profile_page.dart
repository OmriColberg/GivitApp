import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/models/transport.dart';
import 'package:givit_app/core/shared/assign_card_transport.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/core/shared/assign_card_product.dart';
import 'package:givit_app/profile_page_feature/presentation/pages/edit_profile_page.dart';
import 'package:givit_app/services/database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final Size size;

  ProfilePage({required this.size});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    GivitUser user = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: user.uid);
    return StreamBuilder<GivitUser>(
      stream: db.givitUserData,
      builder: (context, snapshotGivitUser) {
        if (snapshotGivitUser.hasError) {
          print(snapshotGivitUser.error);
          return Text(snapshotGivitUser.error.toString() +
              'אירעה תקלה, נא לפנות למנהלים');
        }

        if (snapshotGivitUser.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        GivitUser? givitUser = snapshotGivitUser.data;
        return Container(
          color: Colors.blue[100],
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              size: widget.size,
                              givitUser: givitUser,
                            ),
                          ),
                        ),
                      },
                      child: Text('עריכת פרטים אישיים'),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'שלום ${givitUser!.fullName}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: db.producstData,
                    builder: (context, snapshotProduct) {
                      if (snapshotProduct.hasError) {
                        return Text(snapshotProduct.error.toString() +
                            'אירעה תקלה, נא לפנות למנהלים');
                      }

                      if (snapshotProduct.connectionState ==
                          ConnectionState.waiting) {
                        return Loading();
                      }

                      return StreamBuilder<QuerySnapshot>(
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

                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                snapshotProduct.data!.docs
                                    .map((DocumentSnapshot document) {
                                  if (givitUser.products
                                      .contains(document.id)) {
                                    var snapshotData = document.data() as Map;
                                    Product product =
                                        Product.productFromDocument(
                                            snapshotData, document.id);

                                    return createDeliveryAssignFromProductSnapshot(
                                        product,
                                        givitUser.products,
                                        widget.size,
                                        givitUser.role == 'Admin');
                                  } else
                                    return Container();
                                }).toList(),
                                snapshotTransport.data!.docs
                                    .map((DocumentSnapshot document) {
                                  var snapshotData = document.data() as Map;
                                  Transport transport =
                                      Transport.transportFromDocument(
                                          snapshotData, document.id);
                                  if (givitUser.transports
                                      .contains(transport.id)) {
                                    return createDeliveryAssignFromTransportSnapshot(
                                        transport,
                                        givitUser.transports,
                                        widget.size,
                                        givitUser.role == 'Admin');
                                  } else
                                    return Container();
                                }).toList(),
                              ].expand((element) => element).toList(),
                            ),
                          );
                        },
                      );
                    },
                  ),
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
    Product product, List<String> products, Size size, bool isAdmin) {
  return AssignCardProduct(
    title: product.name,
    body: product.notes,
    schedule: 'לשיבוץ חיפוש',
    type: CardType.personal,
    product: product,
    personalProducts: products,
    size: size,
    isAdmin: isAdmin,
  );
}

AssignCardTransport createDeliveryAssignFromTransportSnapshot(
    Transport transport, List<String> transports, Size size, bool isAdmin) {
  String date =
      DateFormat('yyyy-MM-dd HH:mm').format(transport.datePickUp).toString();
  return AssignCardTransport(
    title: date + ' :הובלה ב' + '\n' + transport.pickUpAddress + ' :יוצאת מ',
    body: transport.notes,
    schedule: 'לשיבוץ הובלה',
    type: CardType.personal,
    transport: transport,
    personalTransport: transports,
    size: size,
    isAdmin: isAdmin,
  );
}
