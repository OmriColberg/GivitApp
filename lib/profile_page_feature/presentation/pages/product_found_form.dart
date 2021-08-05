import 'dart:io' as io;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/shared/constant.dart';
import 'package:givit_app/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductFoundForm extends StatefulWidget {
  final Size size;
  final Product product;
  final List<String> products;
  ProductFoundForm(
      {required this.size, required this.product, required this.products});

  @override
  _ProductFoundFormState createState() => _ProductFoundFormState();
}

class _ProductFoundFormState extends State<ProductFoundForm> {
  final _formKey = GlobalKey<FormState>();
  String error = '';

  bool pickedImage = false;
  String productImagePath = '';
  int weight = 0;
  int length = 0;
  int width = 0;
  ProductState state = ProductState.unknown;
  String ownerName = '';
  late int ownerPhoneNumber;
  String pickUpAddress = '';
  String timeForPickUp = '';
  String notes = '';
  ProductStatus status = ProductStatus.searching;

  @override
  Widget build(BuildContext context) {
    GivitUser user = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: user.uid);
    final ImagePicker _picker = ImagePicker();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          elevation: 0.0,
          title: Text('מצאתי מוצר'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'שם מוסר/ת המוצר'),
                      validator: (val) =>
                          val!.isEmpty ? 'הכנס/י את שם מוסר/ת המוצר' : null,
                      onChanged: (val) {
                        setState(() => ownerName = val);
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.brown,
                        ),
                        onTap: () async {
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);

                          setState(() {
                            pickedImage = true;
                            productImagePath = image!.path;
                          });
                        },
                      ),
                      SizedBox(width: 10),
                      pickedImage
                          ? ClipOval(
                              child: Image.file(
                                File(productImagePath),
                                fit: BoxFit.fill,
                                height: 50,
                                width: 50,
                              ),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: ExactAssetImage(
                                      'lib/core/assets/default_furniture_pic.jpeg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      SizedBox(width: 10),
                      DropdownButton<String>(
                        value: Product.hebrewFromEnum(state),
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 20,
                        elevation: 1,
                        style: const TextStyle(color: Colors.blue),
                        underline: Container(
                          height: 1.5,
                          color: Colors.blue,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            state = Product.productStateFromString(newValue!);
                          });
                        },
                        items: <String>['חדש', 'כמו חדש', 'משומש', 'לא ידוע']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      Text("   :מצב המוצר"),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'טלפון מוסר/ת המוצר'),
                      validator: (val) => val!.length != 10
                          ? "הכנס מס' טלפון של מוסר המוצר"
                          : null,
                      onChanged: (val) {
                        setState(() => ownerPhoneNumber = int.parse(val));
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'כתובת לאיסוף'),
                      validator: (val) =>
                          val!.isEmpty ? "הכנס כתובת לאיסוף המוצר" : null,
                      onChanged: (val) {
                        setState(() => pickUpAddress = val);
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'מועד לאיסוף המוצר'),
                      validator: (val) =>
                          val!.isEmpty ? "הכנס מועד לאיסוף המוצר" : null,
                      onChanged: (val) {
                        setState(() => timeForPickUp = val);
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'משקל בקילוגרמים'),
                      onChanged: (val) {
                        setState(() => weight = int.parse(val));
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'אורך בס"מ'),
                      onChanged: (val) {
                        setState(() => length = int.parse(val));
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'רוחב בס"מ'),
                      onChanged: (val) {
                        setState(() => width = int.parse(val));
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'הערות נוספות'),
                      onChanged: (val) {
                        setState(() => notes = val);
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    child: Text(
                      'עדכון פרטי המוצר שנמצא',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        notes = notes == '' ? 'אין הערות' : notes;
                        await db.updateProductFields(widget.product.id, {
                          "Owner's Name": ownerName,
                          'State Of Product': state.toString().split('.')[1],
                          "Owner's Phone Number": ownerPhoneNumber,
                          'Pick Up Address': pickUpAddress,
                          'Time Span For Pick Up': timeForPickUp,
                          'Weight': weight,
                          'Length': length,
                          'Width': width,
                          'Notes': notes,
                          'Status Of Product': ProductStatus
                              .waitingToBeDelivered
                              .toString()
                              .split('.')[1],
                        }).then((_result) {
                          showDialogHelper(
                              "תודה על מציאת המוצר!\nפרטי המוצר עודכנו, ממתין לשיבוץ הובלה",
                              widget.size);
                        }).catchError((error) {
                          showDialogHelper(
                              "קרתה תקלה, נסה שוב ($error)", widget.size);
                        });
                        widget.products.remove(widget.product.id);
                        await db.updateGivitUserFields(
                            {'Products': widget.products});
                        await db
                            .deleteProductFromGivitUserList(widget.product.id);
                        Reference reference = db.storage
                            .ref()
                            .child('Products pictures/${widget.product.id}');
                        UploadTask uploadTask =
                            reference.putFile(io.File(productImagePath));
                        await uploadTask.whenComplete(
                            () => reference.getDownloadURL().then((fileURL) => {
                                  db.updateProductFields(widget.product.id,
                                      {'Product Picture URL': fileURL})
                                }));
                        setState(() {
                          notes = '';
                          ownerName = '';
                          pickUpAddress = '';
                          timeForPickUp = '';
                        });
                        _formKey.currentState!.reset();
                      }
                    },
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showDialogHelper(String dialogText, Size size) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: size.height * 0.5,
            child: AlertDialog(
                title: Text(dialogText),
                content: Stack(children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("לחזרה"),
                  ),
                ])),
          );
        });
  }
}
