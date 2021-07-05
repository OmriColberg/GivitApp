import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/core/shared/assign_card.dart';
import 'package:givit_app/profile_page_feature/presentation/pages/edit_profile_page.dart';
import 'package:givit_app/services/database.dart';
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
        print("PRODUCTS: ${givitUser!.products}");
        return Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hello ${givitUser.fullName}',
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
              Container(
                height: 400,
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
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

                      return Column(
                        children: snapshotProduct.data!.docs
                            .map((DocumentSnapshot document) {
                          if (givitUser.products.contains(document.id)) {
                            var snapshotData = document.data() as Map;
                            Product product = Product.productFromDocument(
                                snapshotData, document.id);
                            return createDeliveryAssignFromProductSnapshot(
                                product, givitUser.products, widget.size);
                          } else {
                            return Container();
                          }
                        }).toList(),
                      );
                    },
                  ),
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
