import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/shared/constant.dart';
import 'package:givit_app/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class AddProductWarehousePage extends StatefulWidget {
  final Size size;
  AddProductWarehousePage({required this.size});

  @override
  _AddProductWarehousePageState createState() =>
      _AddProductWarehousePageState();
}

class _AddProductWarehousePageState extends State<AddProductWarehousePage> {
  final _formKey = GlobalKey<FormState>();
  String produtcName = '';
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
          title: Text('הוספת מוצר מהמחסן'),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'שם המוצר'),
                      validator: (val) =>
                          val!.isEmpty ? 'הכנס/י שם מוצר' : null,
                      onChanged: (val) {
                        setState(() => produtcName = val);
                      },
                    ),
                  ),
                  SizedBox(height: 10),
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
                  SizedBox(height: 10),
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
                  SizedBox(height: 10),
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
                  SizedBox(height: 10),
                  ElevatedButton(
                    child: Text(
                      'הוסף מוצר למערכת',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        notes = notes == '' ? 'אין הערות' : notes;
                        String productId = '';
                        await db
                            .addProduct(
                                name: produtcName,
                                notes: notes,
                                productState: state.toString().split('.')[1],
                                ownerName: ownerName,
                                ownerPhoneNumber: ownerPhoneNumber,
                                timePickUp: timeForPickUp,
                                pickUpAddress: pickUpAddress,
                                productPictureUrl: '',
                                assignTransportId: '',
                                weight: weight,
                                length: length,
                                width: width,
                                productStatus: ProductStatus
                                    .waitingToBeDelivered
                                    .toString()
                                    .split('.')[1])
                            .then((_result) {
                          productId = _result;
                          print(
                              'This is the ID of the product that just added: $_result');
                          showDialogHelper("המוצר התווסף בהצלחה", widget.size);
                        }).catchError((error) {
                          showDialogHelper(
                              "קרתה תקלה, נסה שוב ($error)", widget.size);
                        });
                        Reference reference = db.storage
                            .ref()
                            .child('Products pictures/$productId');
                        UploadTask uploadTask =
                            reference.putFile(File(productImagePath));
                        await uploadTask.whenComplete(
                            () => reference.getDownloadURL().then((fileURL) => {
                                  db.updateProductFields(productId,
                                      {'Product Picture URL': fileURL})
                                }));
                        setState(() {
                          notes = '';
                          produtcName = '';
                          ownerName = '';
                          pickUpAddress = '';
                          timeForPickUp = '';
                          productImagePath = '';
                          pickedImage = false;
                        });
                        _formKey.currentState!.reset();
                      }
                    },
                  ),
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
            content: Stack(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("לחזרה"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
