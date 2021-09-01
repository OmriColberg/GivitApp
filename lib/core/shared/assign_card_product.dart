import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/shared/product_found_form.dart';
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
  final bool isAdmin;
  AssignCardProduct(
      {required this.title,
      required this.body,
      required this.schedule,
      required this.product,
      required this.personalProducts,
      required this.size,
      required this.type,
      required this.isAdmin});

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
                        onTap: () async {
                          personalProducts.remove(product.id);
                          await db.updateGivitUserFields(
                              {'Products': personalProducts});
                        },
                      )
                    : isAdmin
                        ? InkWell(
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.red[900],
                            ),
                            onTap: () {
                              showDialogHelper("אישור מחיקת מוצר ממאגר המידע",
                                  size, context, db);
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
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: size.height * 0.5,
                              child: AlertDialog(
                                title: Text(
                                    'תודה רבה! השתבצת לחיפוש מוצר. \nתוכל/י לראות את פרטי המוצר המבוקש באזור האישי.\nחיפוש נעים :)'),
                                content: ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("אישור"),
                                ),
                              ),
                            );
                          },
                        );
                        await db.updateGivitUserFields({
                          "Products": FieldValue.arrayUnion(['${product.id}'])
                        });
                      },
                      child: Text(schedule),
                    ),
                  ])
                : type == CardType.personal
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductFoundForm(
                                size: size,
                                product: product,
                                products: personalProducts,
                                length: 0,
                                ownerName: '',
                                productImagePath: '',
                                state: ProductState.unknown,
                                weigth: 0,
                                width: 0,
                                notes: '',
                                ownerPhoneNumber: '',
                                pickUpAddress: '',
                                timeForPickUp: '',
                                isUpdate: false,
                                pickedImage: false,
                              ),
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

  void showDialogHelper(
      String dialogText, Size size, BuildContext context, DatabaseService db) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: size.height * 0.5,
          child: AlertDialog(
            title: Text(dialogText),
            content: Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await db.deleteProductFromProductList(product.id);
                    await db.deleteProductFromGivitUserList(product.id);
                  },
                  child: Text("מחיקה"),
                ),
                SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("ביטול"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum CardType { main, personal, admin }
