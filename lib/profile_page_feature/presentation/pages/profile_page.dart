import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/models/transport.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/core/shared/assign_card.dart';
import 'package:givit_app/main_page_feature/presentation/pages/main_page.dart';
import 'package:givit_app/profile_page_feature/presentation/pages/edit_profile_page.dart';
import 'package:givit_app/services/database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final Size size;

  const ProfilePage({required this.size});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    GivitUser user = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: user.uid);
    return StreamBuilder<GivitUser>(
      stream: db.userData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        }
        GivitUser? givitUser = snapshot.data;
        return Container(
          color: Colors.blue[100],
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hello ${givitUser!.fullName}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProfilePage(size: widget.size),
                        ),
                      ),
                    },
                    child: Text('Edit Personal Info'),
                  )
                ],
              ),
              SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: db.producstData,
                  builder: (context, snapshotProduct) {
                    if (snapshotProduct.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshotProduct.connectionState ==
                        ConnectionState.waiting) {
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

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              snapshotProduct.data!.docs
                                  .map((DocumentSnapshot document) {
                                if (givitUser.products.contains(document.id)) {
                                  var snapshotData = document.data() as Map;
                                  Product product = Product.productFromDocument(
                                      snapshotData, document.id);
                                  return createDeliveryAssignFromProductSnapshot(
                                      product, givitUser.products, widget.size);
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
                                      transport, widget.size);
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
        );
      },
    );
  }
}

DeliveryAssign createDeliveryAssignFromProductSnapshot(
    Product product, List<String> products, Size size) {
  return DeliveryAssign(
    title: product.name,
    body: product.notes,
    schedule: 'לשיבוץ חיפוש',
    isProduct: true,
    isMain: false,
    id: product.id,
    products: products,
    size: size,
  );
}

DeliveryAssign createDeliveryAssignFromTransportSnapshot(
    Transport transport, Size size) {
  String date;
  if (transport.datePickUp != null) {
    date =
        DateFormat('yyyy-MM-dd hh:mm').format(transport.datePickUp).toString();
  } else {
    date = '';
  }
  return DeliveryAssign(
    title: date + ' :הובלה ב',
    body: transport.notes,
    schedule: 'לשיבוץ הובלה',
    isProduct: false,
    isMain: true,
    id: transport.id,
    products: [],
    size: size,
  );
}
