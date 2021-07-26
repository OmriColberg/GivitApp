import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/shared/assign_card_product.dart';
import 'package:givit_app/core/shared/constant.dart';
import 'package:givit_app/services/database.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddTransportPage extends StatefulWidget {
  final Size size;
  final List<MultiSelectItem<Product?>> productsToBeDelivered;
  AddTransportPage({required this.size, required this.productsToBeDelivered});

  @override
  _AddTransportPageState createState() => _AddTransportPageState();
}

class _AddTransportPageState extends State<AddTransportPage> {
  final _formKey = GlobalKey<FormState>();
  String error = '';

  int totalNumOfCarriers = 0;
  String destinationAddress = '';
  String pickUpAddress = '';
  String notes = '';
  List<String> products = const [];
  DateTime datePickUp = DateTime.now(); // TODO: select date with calender

  @override
  Widget build(BuildContext context) {
    GivitUser user = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: user.uid);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          elevation: 0.0,
          title: Text('    בחירת מוצרים להובלה '),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            color: Colors.blue[100],
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: MultiSelectDialogField<Product?>(
                      items: widget.productsToBeDelivered,
                      title: Text("מוצרים לבחירה"),
                      selectedColor: Colors.blue,
                      buttonText: Text("בחר/י מוצרים להובלה"),
                      onConfirm: (results) {
                        products = results
                            .map((Product? product) => product!.id)
                            .toList()
                            .cast<String>();
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'מספר מובילים'),
                      validator: (val) =>
                          val!.isEmpty ? 'הכנס מספר מובילים' : null,
                      onChanged: (val) {
                        setState(() => totalNumOfCarriers = int.parse(val));
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'כתובת יעד'),
                      validator: (val) =>
                          val!.isEmpty ? 'הכנס כתובת יעד' : null,
                      onChanged: (val) {
                        setState(() => destinationAddress = val);
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'כתובת התחלה'),
                      validator: (val) =>
                          val!.isEmpty ? 'הכנס כתובת התחלה' : null,
                      onChanged: (val) {
                        setState(() => pickUpAddress = val);
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'הערות'),
                      onChanged: (val) {
                        setState(() => notes = val);
                      },
                    ),
                  ),
                  SizedBox(height: 12.0),
                  TextButton(
                      // TODO: complete
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2018, 3, 5),
                            maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          print('confirm $date');
                        }, currentTime: DateTime.now(), locale: LocaleType.zh);
                      },
                      child: Text(
                        'show date time picker (Chinese)',
                        style: TextStyle(color: Colors.blue),
                      )),
                  SizedBox(height: 12.0),
                  ElevatedButton(
                    child: Text(
                      'הוסף הובלה למערכת',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (products.isNotEmpty) {
                          await db
                              .addTransport(
                            products: products,
                            datePickUp: datePickUp,
                            totalNumOfCarriers: totalNumOfCarriers,
                            destinationAddress: destinationAddress,
                            pickUpAddress: pickUpAddress,
                            notes: notes,
                          )
                              .then((_result) {
                            print(
                                'This is the ID of the transport that just added: $_result');
                            showDialogHelper(
                                "ההובלה התווספה בהצלחה", widget.size);
                          }).catchError((error) {
                            showDialogHelper(
                                "קרתה תקלה, נסה שוב ($error)", widget.size);
                          });
                          await db
                              .updateAssignProducts(
                                  products, ProductStatus.assignToDelivery)
                              .then((_) => products.forEach((id) {
                                    print(
                                        'the product with the id: $id were updated to delivery');
                                  }))
                              .onError((error, stackTrace) =>
                                  print("קרתה תקלה, נסה שוב ($error)"));
                          _formKey.currentState!.reset();
                        } else {
                          error = 'ההובלה חייבת לכלול לפחות מוצר 1';
                        }
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

AssignCardProduct createDeliveryAssignFromProductSnapshot(
    Product product, Size size) {
  return AssignCardProduct(
    title: product.name,
    body: product.notes,
    schedule: 'לשיבוץ חיפוש',
    type: CardType.admin,
    product: product,
    personalProducts: [],
    size: size,
  );
}
