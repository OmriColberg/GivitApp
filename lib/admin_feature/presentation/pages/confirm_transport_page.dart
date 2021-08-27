import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/models/transport.dart';
import 'package:givit_app/core/shared/constant.dart';
import 'package:givit_app/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class ConfirmTranportPage extends StatefulWidget {
  final Size size;
  final GivitUser? givitUser;
  final Transport transport;
  final List<Product> products;
  ConfirmTranportPage(
      {required this.size,
      required this.givitUser,
      required this.transport,
      required this.products});

  @override
  _ConfirmTranportPageState createState() =>
      _ConfirmTranportPageState(size: size, givitUser: givitUser);
}

class _ConfirmTranportPageState extends State<ConfirmTranportPage> {
  final Size size;
  final GivitUser? givitUser;
  int numOfPhotos = 0;
  List<XFile>? images = [];
  _ConfirmTranportPageState({required this.size, required this.givitUser});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GivitUser user = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: user.uid);
    final ImagePicker _picker = ImagePicker();
    String sumUp = '';

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          elevation: 0.0,
          title: Text('אישור ביצוע ההובלה'),
        ),
        body: Container(
          height: size.height * 0.3,
          color: Colors.blue[300],
          child: Column(
            children: [
              Directionality(
                textDirection: ui.TextDirection.rtl,
                child: TextField(
                  minLines: 3,
                  maxLines: 5,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'פירוט אודות ההובלה לקבילת גיביט'),
                  onChanged: (sumUPText) {
                    sumUp = sumUPText;
                  },
                ),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  images = await _picker.pickMultiImage();
                  setState(() {
                    numOfPhotos = images!.length;
                  });
                },
                child: Text("לבחירת תמונות"),
              ),
              numOfPhotos > 0
                  ? numOfPhotos > 1
                      ? Text("נבחרו $numOfPhotos תמונות, והן ממש יפות")
                      : Flexible(
                          child: Text(
                              "נבחרה רק תמונה אחת, מומלץ לבחור מספר תמונות מיום ההובלה"),
                        )
                  : Text("לא נבחרו תמונות"),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  String transportId = '';
                  List<String> productsNames = [];
                  List<Reference> picturesReferences = [];
                  List<Reference> productsRefrences = [];

                  Navigator.of(context).pop();
                  await db.moveTransportCollection(
                      widget.transport, 'Transports', 'Community Transports', {
                    'Current Number Of Carriers':
                        widget.transport.currentNumOfCarriers,
                    'Total Number Of Carriers':
                        widget.transport.totalNumOfCarriers,
                    'Destination Address': widget.transport.destinationAddress,
                    'Pick Up Address': widget.transport.pickUpAddress,
                    'Date For Pick Up': widget.transport.datePickUp.toString(),
                    'Products': [],
                    'Carriers': widget.transport.carriers,
                    'Carriers Phone Numbers':
                        widget.transport.carriersPhoneNumbers,
                    'Status Of Transport':
                        TransportStatus.carriedOut.toString().split('.')[1],
                    'Pictures': [],
                    'Notes': widget.transport.notes,
                    'SumUp': sumUp,
                  }).then((_result) => transportId = _result);

                  for (int i = 0; i < images!.length; i++) {
                    picturesReferences.add(db.storage
                        .ref()
                        .child('Transport pictures/$transportId/$i'));
                    UploadTask uploadTask =
                        picturesReferences[i].putFile((File(images![i].path)));
                    uploadTask.whenComplete(() => picturesReferences[i]
                        .getDownloadURL()
                        .then((fileURL) => db.updateTransportFields(
                                'Community Transports', transportId, {
                              "Pictures": FieldValue.arrayUnion(['$fileURL'])
                            })));
                  }
                  widget.products.forEach((product) {
                    productsNames.add(product.name);
                  });

                  await db
                      .deleteTransportFromGivitUserList(widget.transport.id);
                  await db.updateTransportFields(
                      'Community Transports', transportId, {
                    'Products': productsNames,
                  });

                  for (int i = 0; i < widget.transport.products.length; i++) {
                    productsRefrences.add(db.storage.ref().child(
                        'Products pictures/${widget.transport.products[i]}'));
                    await productsRefrences[i].delete().then((_) => null);
                    await db.deleteProductFromProductList(
                        widget.transport.products[i]);
                  }
                },
                child: Text("לאישור"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
