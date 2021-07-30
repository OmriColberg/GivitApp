import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/profile_page_feature/presentation/pages/product_found_form.dart';
import 'package:givit_app/services/database.dart';
import 'package:provider/provider.dart';

class AssignCardProduct extends StatelessWidget {
  final String title;
  final String schedule;
  final String body;
  final Product product;
  final List<String> personalProducts;
  final Size size;
  final CardType type;
  AssignCardProduct({
    required this.title,
    required this.body,
    required this.schedule,
    required this.product,
    required this.personalProducts,
    required this.size,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final GivitUser givitUser = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: givitUser.uid);
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(4),
        ),
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SvgPicture.asset('lib/core/assets/sofa_icon.svg',
                    height: 24, width: 24),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                type == CardType.personal
                    ? InkWell(
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                        ),
                        onTap: () {
                          personalProducts.remove(product.id);
                          db.updateGivitUserFields(
                              {'Products': personalProducts});
                        },
                      )
                    : Container()
              ],
            ),
            Text(
              body,
              style: TextStyle(fontSize: 16),
            ),
            type == CardType.main
                ? Column(children: [
                    ElevatedButton(
                      onPressed: () {
                        db.updateGivitUserFields({
                          "Products": FieldValue.arrayUnion(['${product.id}'])
                        });
                      },
                      child: Text(schedule),
                    ),
                  ])
                : type == CardType.personal
                    ? ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductFoundForm(
                                  size: size,
                                  product: product,
                                  products: personalProducts),
                            ),
                          );
                        },
                        child: Text('מצאתי'),
                      )
                    : Container(), // transport in admin
          ],
        ),
      ),
    );
  }
}

enum CardType { main, personal, admin }
