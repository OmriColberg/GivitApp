import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/admin_feature/presentation/pages/confirm_transport_page.dart';
import 'package:givit_app/admin_feature/presentation/pages/update_transport_page.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/models/transport.dart';
import 'package:givit_app/core/shared/assign_card_product.dart';
import 'package:givit_app/core/shared/constant.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/core/shared/product_found_form.dart';
import 'package:givit_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sms/flutter_sms.dart';

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
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: db.givitUsersData,
      builder: (context, snapshotUsers) {
        if (snapshotUsers.hasError) {
          print(snapshotUsers.error);
          return Text(
              snapshotUsers.error.toString() + 'אירעה תקלה, נא לפנות למנהלים');
        }

        if (snapshotUsers.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        return StreamBuilder<QuerySnapshot<Object?>>(
          stream: db.producstData,
          builder: (context, snapshotProduct) {
            if (snapshotProduct.hasError) {
              print(snapshotProduct.error);
              return Text(snapshotProduct.error.toString() +
                  'אירעה תקלה, נא לפנות למנהלים');
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
                                        'Transports', transport.id, {
                                      'Status Of Transport':
                                          "waitingForVolunteers"
                                    });
                                  }
                                  String userPhoneNumber =
                                      (await db.getUserByID(db.uid))
                                          .phoneNumber;
                                  await db.updateGivitUserFields(
                                      {'Transports': personalTransport});
                                  await db.updateTransportFields(
                                      'Transports', transport.id, {
                                    'Current Number Of Carriers':
                                        transport.currentNumOfCarriers - 1,
                                    "Carriers":
                                        FieldValue.arrayRemove(['${db.uid}']),
                                    "Carriers Phone Numbers":
                                        FieldValue.arrayRemove(
                                            ['$userPhoneNumber']),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              isAdmin && type == CardType.admin
                                  ? InkWell(
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.blue[600],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateTransportPage(
                                                    datePickUp:
                                                        transport.datePickUp,
                                                    destinationAddress:
                                                        transport
                                                            .destinationAddress,
                                                    notes: transport.notes,
                                                    pickUpAddress:
                                                        transport.pickUpAddress,
                                                    size: size,
                                                    totalNumOfCarriers:
                                                        transport
                                                            .totalNumOfCarriers,
                                                    transportId: transport.id,
                                                    carrier: transport.carrier,
                                                    carrierPhoneNumber:
                                                        transport
                                                            .carrierPhoneNumber,
                                                  )),
                                        );
                                      },
                                    )
                                  : Container(),
                              Text(
                                'נרשמו ${transport.currentNumOfCarriers} מתוך  ${transport.totalNumOfCarriers} מובילים',
                                style: TextStyle(fontSize: 16),
                              ),
                              isAdmin && type == CardType.admin
                                  ? InkWell(
                                      child: Icon(
                                        Icons.sms,
                                        color: Colors.blue[600],
                                      ),
                                      onTap: () {
                                        showDialogPhone(
                                            "אישור שליחת הודעה תזכורת לכלל המתנדבים הרשומים",
                                            size,
                                            context,
                                            db,
                                            transport);
                                      },
                                    )
                                  : Container()
                            ],
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
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: size.height * 0.5,
                                          child: AlertDialog(
                                            title: Text(
                                                'השתבצת להובלה, תודה רבה וכל הכבוד!\nתוכל/י לראות את פרטי ההובלה באזור האישי\n"גם כשלא מבקשים ממכם אצבע, תדאגו לבדוק אולי למישהו חסרה יד" :)'),
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
                                      "Transports": FieldValue.arrayUnion(
                                          ['${transport.id}'])
                                    });
                                    String userPhoneNumber =
                                        (await db.getUserByID(db.uid))
                                            .phoneNumber;
                                    await db.updateTransportFields(
                                        'Transports', transport.id, {
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
                                          FieldValue.arrayUnion(['${db.uid}']),
                                      "Carriers Phone Numbers":
                                          FieldValue.arrayUnion(
                                              ['$userPhoneNumber']),
                                    });
                                  },
                                  child: Text(schedule),
                                ))
                              : type == CardType.personal
                                  ? Text(
                                      "\"עם הרשמות להובלה גדולה מגיעה אחריות גדולה\"",
                                      style: TextStyle(fontSize: 14),
                                    )
                                  : (transport.datePickUp
                                              .compareTo(DateTime.now()) <=
                                          0
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            List<Product> products = [];
                                            transport.products
                                                .forEach((productId) async {
                                              products.add(await db
                                                  .getProductByID(productId));
                                            });

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ConfirmTranportPage(
                                                  size: size,
                                                  givitUser: givitUser,
                                                  transport: transport,
                                                  products: products,
                                                ),
                                              ),
                                            );
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
                        Reference reference;
                        String productId = product.id;
                        reference = db.storage
                            .ref()
                            .child('Products pictures/$productId');
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
                        await reference
                            .delete()
                            .then((_) => print(
                                'Successfully deleted Products Picture/$productId storage item'))
                            .onError(
                                (error, stackTrace) => print(error.toString()));
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

  void showTransportDelete(
      String dialogText, Size size, BuildContext context, DatabaseService db) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: size.height * 0.7,
          child: AlertDialog(
            insetPadding: EdgeInsets.all(10),
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
                    smsSender(db, transport,
                        "ההובלה שהייתה אמורה להתקיים בתאריך ה${transport.datePickUp.day}.${transport.datePickUp.month}.${transport.datePickUp.year} בשעה ${transport.datePickUp.hour}:${transport.datePickUp.minute} מ${transport.pickUpAddress} התבטלה. תודה על הושטת היד!");
                  },
                  child: Text("מחיקה ושליחת SMS"),
                ),
                SizedBox(width: 5),
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

  void showDialogPhone(String dialogText, Size size, BuildContext context,
      DatabaseService db, Transport transport) {
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
                    smsSender(db, transport,
                        "תזכורת: בתאריך ה${transport.datePickUp.day}.${transport.datePickUp.month}.${transport.datePickUp.year} בשעה ${transport.datePickUp.hour}:${transport.datePickUp.minute} תתבצע הובלה מ${transport.pickUpAddress}. תודה על התנדבותך!");
                  },
                  child: Text("שליחת הודעות"),
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

  void smsSender(DatabaseService db, Transport transport, String SmsContent) {
    sendSMS(message: SmsContent, recipients: transport.carriersPhoneNumbers);
  }
}
