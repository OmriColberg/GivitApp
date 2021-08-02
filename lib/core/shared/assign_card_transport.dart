import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/models/transport.dart';
import 'package:givit_app/core/shared/assign_card_product.dart';
import 'package:givit_app/core/shared/constant.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AssignCardTransport extends StatelessWidget {
  final String title;
  final String schedule;
  final String body;
  final Transport transport;
  final List<String> personalTransport;
  final Size size;
  final CardType type;
  final bool isAdmin;

  AssignCardTransport({
    required this.title,
    required this.body,
    required this.schedule,
    required this.transport,
    required this.personalTransport,
    required this.size,
    required this.type,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final GivitUser givitUser = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: givitUser.uid);
    int prodIndex = 0;
    int userIndex = 0;
    return StreamBuilder<QuerySnapshot>(
      stream: db.givitUsersData,
      builder: (context, snapshotUsers) {
        if (snapshotUsers.hasError) {
          print(snapshotUsers.error);
          return Text('אירעה תקלה, נא לפנות למנהלים');
        }

        if (snapshotUsers.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        return StreamBuilder<QuerySnapshot>(
          stream: db.producstData,
          builder: (context, snapshotProduct) {
            if (snapshotProduct.hasError) {
              print(snapshotProduct.error);
              return Text('אירעה תקלה, נא לפנות למנהלים');
            }

            if (snapshotProduct.connectionState == ConnectionState.waiting) {
              return Loading();
            }

            return Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(4),
                ),
                color: Colors.deepPurple[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.airport_shuttle),
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
                                  personalTransport.remove(transport.id);
                                  if (transport.currentNumOfCarriers ==
                                      transport.totalNumOfCarriers) {
                                    await db.updateTransportFields(
                                        transport.id, {
                                      'Status Of Transport':
                                          "waitingForVolunteers"
                                    });
                                  }
                                  await db.updateGivitUserFields(
                                      {'Transports': personalTransport});
                                  await db.updateTransportFields(transport.id, {
                                    'Current Number Of Carriers':
                                        transport.currentNumOfCarriers - 1,
                                    "Carriers":
                                        FieldValue.arrayRemove(['${db.uid}'])
                                  });
                                },
                              )
                            : isAdmin
                                ? InkWell(
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red[900],
                                    ),
                                    onTap: () {
                                      showTransportDelete(
                                          "אישור מחיקת הובלה ממאגר המידע",
                                          size,
                                          context,
                                          db);
                                    },
                                  )
                                : Container()
                      ],
                    ),
                    Text(
                      body,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        snapshotProduct.data!.docs
                            .map((DocumentSnapshot document) {
                          if (transport.products.contains(document.id)) {
                            var snapshotData = document.data() as Map;
                            Product product = Product.productFromDocument(
                                snapshotData, document.id);
                            if (transport.status.toString() !=
                                ProductStatus.searching.toString()) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${++prodIndex}. " + product.name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    child: ClipOval(
                                      child: Image.network(
                                        product.productPictureURL,
                                        fit: BoxFit.fill,
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                    onTap: () {
                                      showProductInfo(
                                          product, size, context, db);
                                    },
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        }).toList(),
                        [
                          Text(
                            'נרשמו ${transport.currentNumOfCarriers} מתוך  ${transport.totalNumOfCarriers} מובילים',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                        snapshotUsers.data!.docs
                            .map((DocumentSnapshot document) {
                          GivitUser user = GivitUser.fromFirestorUser(document);
                          if (transport.carriers.contains(user.uid)) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  user.fullName + " .${++userIndex}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(width: 10),
                                ClipOval(
                                  child: Image.network(
                                    user.profilePictureURL,
                                    fit: BoxFit.fill,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }).toList(),
                        [
                          type == CardType.main
                              ? (ElevatedButton(
                                  onPressed: () async {
                                    await db.updateGivitUserFields({
                                      "Transports": FieldValue.arrayUnion(
                                          ['${transport.id}'])
                                    });
                                    await db
                                        .updateTransportFields(transport.id, {
                                      'Status Of Transport':
                                          transport.currentNumOfCarriers + 1 ==
                                                  transport.totalNumOfCarriers
                                              ? TransportStatus
                                                  .waitingForDueDate
                                                  .toString()
                                                  .split('.')[1]
                                              : TransportStatus
                                                  .waitingForVolunteers
                                                  .toString()
                                                  .split('.')[1],
                                      'Current Number Of Carriers':
                                          transport.currentNumOfCarriers + 1,
                                      "Carriers":
                                          FieldValue.arrayUnion(['${db.uid}'])
                                    });
                                  },
                                  child: Text(schedule),
                                ))
                              : type == CardType.personal
                                  ? Text(
                                      "\"עם הרשמות להובלה גדולה מגיעה אחריות גדולה\"",
                                      style: TextStyle(fontSize: 14),
                                    )
                                  : (transport.currentNumOfCarriers ==
                                          transport.totalNumOfCarriers
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            showDialogPost(
                                                "הוספת פוסט לקהילת גיביט",
                                                size,
                                                context,
                                                db,
                                                transport);
                                            await db.updateTransportFields(
                                                transport.id, {
                                              'Status Of Transport':
                                                  TransportStatus.carriedOut
                                                      .toString()
                                                      .split('.')[1],
                                            });
                                            await db.updateAssignProducts(
                                                personalTransport, {
                                              'Status Of Product': ProductStatus
                                                  .delivered
                                                  .toString()
                                                  .split('.')[1],
                                            });
                                            await db
                                                .deleteTransportFromGivitUserList(
                                                    transport.id);
                                          },
                                          child: Text("אישור ביצוע ההובלה"),
                                        )
                                      : Container())
                        ]
                      ].expand((element) => element).toList(),
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

  void showProductInfo(
      Product product, Size size, BuildContext context, DatabaseService db) {
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
                        Navigator.of(context).pop();
                        await db.deleteProductFromProductList(product.id);
                        Transport transport = await db
                            .getTransportByID(product.assignedTransportId);
                        if (transport.products.length == 1) {
                          await db
                              .deleteTransportFromTransportList(transport.id);
                          await db.updateAssignGivitUsers(transport.carriers, {
                            "Transports":
                                FieldValue.arrayRemove(['${transport.id}'])
                          });
                        } else {
                          await db.deleteProductFromTransportList(
                              product.id, product.assignedTransportId);
                        }
                      },
                      child: Text('למחיקה'),
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

  void showTransportDelete(
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
                    await db.deleteTransportFromTransportList(transport.id);
                    await db.updateAssignProducts(transport.products, {
                      'Assigned Transport ID': '',
                      'Status Of Product': ProductStatus.waitingToBeDelivered
                          .toString()
                          .split('.')[1]
                    });
                    await db.updateAssignGivitUsers(transport.carriers, {
                      "Transports": FieldValue.arrayRemove(['${transport.id}'])
                    });
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

  void showDialogPost(String dialogText, Size size, BuildContext context,
      DatabaseService db, Transport transport) {
    final ImagePicker _picker = ImagePicker();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String sumUp = '';
        List<XFile>? images = [];
        return Container(
          height: size.height * 0.3,
          child: AlertDialog(
            backgroundColor: Colors.blue[300],
            title: Text(dialogText),
            content: Column(
              children: [
                TextField(
                  minLines: 3,
                  maxLines: 5,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'פירוט אודות ההובלה לקבילת גיביט'),
                  onChanged: (sumUPText) {
                    sumUp = sumUPText;
                  },
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () async {
                    if (await Permission.accessMediaLocation
                        .request()
                        .isGranted) {
                      images = await _picker.pickMultiImage();
                    }
                  },
                  child: Text("לבחירת תמונות"),
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () async {
                    await db
                        .updateTransportFields(transport.id, {'SumUp': sumUp});

                    for (int i = 0; i < images!.length; i++) {
                      Reference reference = db.storage
                          .ref()
                          .child('Transport pictures/${transport.id}/$i');
                      reference.putFile((File(images![i].path))).whenComplete(
                            () => reference.getDownloadURL().then(
                                  (fileURL) => {
                                    db.updateTransportFields(
                                      transport.id,
                                      {
                                        'Pictures':
                                            FieldValue.arrayUnion(['$fileURL}'])
                                      },
                                    ),
                                  },
                                ),
                          );
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text("לאישור"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
