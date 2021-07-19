import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/shared/constant.dart';
import 'package:givit_app/services/database.dart';
import 'package:provider/provider.dart';

class ProductFoundForm extends StatefulWidget {
  final Size size;
  final String id;
  final List<String> products;
  ProductFoundForm(
      {required this.size, required this.id, required this.products});

  @override
  _ProductFoundFormState createState() => _ProductFoundFormState();
}

class _ProductFoundFormState extends State<ProductFoundForm> {
  final _formKey = GlobalKey<FormState>();
  String error = '';

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
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'שם מוסר המוצר'),
                    onChanged: (val) {
                      setState(() => ownerName = val);
                    },
                  ),
                  SizedBox(height: 10.0),
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
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'טלפון מוסר המוצר'),
                    validator: (val) => val!.length != 10
                        ? "הכנס מס' טלפון של מוסר המוצר"
                        : null,
                    onChanged: (val) {
                      setState(() => ownerPhoneNumber = int.parse(val));
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'כתובת לאיסוף'),
                    validator: (val) =>
                        val!.isEmpty ? "הכנס כתובת לאיסוף המוצר" : null,
                    onChanged: (val) {
                      setState(() => pickUpAddress = val);
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'מועד לאיסוף המוצר'),
                    validator: (val) =>
                        val!.isEmpty ? "הכנס מועד לאיסוף המוצר" : null,
                    onChanged: (val) {
                      setState(() => timeForPickUp = val);
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'משקל בקילוגרמים'),
                    onChanged: (val) {
                      setState(() => weight = int.parse(val));
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'אורך בס"מ'),
                    onChanged: (val) {
                      setState(() => length = int.parse(val));
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'רוחב בס"מ'),
                    onChanged: (val) {
                      setState(() => width = int.parse(val));
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'הערות נוספות'),
                    onChanged: (val) {
                      setState(() => notes = val);
                    },
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    child: Text(
                      'עדכון פרטי המוצר שנמצא',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        db.updateProductFields(widget.id, {
                          "Owner's Name": ownerName,
                          'State Of Product': state.toString().split('.')[1],
                          "Owner's Phone Number": ownerPhoneNumber,
                          'Pick Up Address': pickUpAddress,
                          'Time Span For Pick Up': timeForPickUp,
                          'Weight': weight,
                          'Length': length,
                          'Width': width,
                          'Notes': notes,
                          'Status Of Product': 'waitingToBeDelivered',
                        }).then((_result) {
                          showDialogHelper(
                              "תודה על מציאת המוצר!\nפרטי המוצר עודכנו, ממתין לשיבוץ הובלה",
                              widget.size);
                        }).catchError((error) {
                          showDialogHelper(
                              "קרתה תקלה, נסה שוב ($error)", widget.size);
                        });
                        widget.products.remove(widget.id);
                        db.updateGivitUserFields({'Products': widget.products});
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
