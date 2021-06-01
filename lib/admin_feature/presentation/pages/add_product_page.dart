import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/admin_feature/presentation/pages/product_register.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/shared/constant.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/services/auth.dart';

class AddProductPage extends StatefulWidget {
  final Function toggleView;
  AddProductPage({this.toggleView});

  @override
  _RegisterProductPageState createState() => _RegisterProductPageState();
}

class _RegisterProductPageState extends State<AddProductPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String name = '';
  ProductState state = ProductState.brandNew;
  String ownerName = '';
  int ownerPhoneNumber;
  String pickUpAddress = '';
  String timeForPickUp = '';
  String notes = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.blue[100],
              appBar: AppBar(
                backgroundColor: Colors.blue[400],
                elevation: 0.0,
                title: Text('הוספת מוצר'),
              ),
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'שם המוצר'),
                          validator: (val) =>
                              val.isEmpty ? 'הכנס שם מוצר' : null,
                          onChanged: (val) {
                            setState(() => name = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'מצב המוצר'),
                          validator: (val) => val.length < 6
                              ? 'Enter a password 6+ characters long'
                              : null,
                          onChanged: (val) {
                            setState(() => state = ProductState.brandNew);
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'שם מוסר המוצר'),
                          onChanged: (val) {
                            setState(() => ownerName = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'טלפון מוסר המוצר'),
                          validator: (val) => val.length != 10
                              ? "הכנס מס' טלפון של בעל המוצר"
                              : null,
                          onChanged: (val) {
                            setState(() => ownerPhoneNumber = int.parse(val));
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'כתובת לאיסוף'),
                          validator: (val) => val.length != 10
                              ? "הכנס כתובת לאיסוף המוצר"
                              : null,
                          onChanged: (val) {
                            setState(() => pickUpAddress = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'מועד לאיסוף המוצר'),
                          validator: (val) => val.length != 10
                              ? "הכנס מועד לאיסוף המוצר"
                              : null,
                          onChanged: (val) {
                            setState(() => timeForPickUp = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'הערות נוספות'),
                          validator: (val) => val.length != 10
                              ? "הכנס הערות על המוצר או איסופו"
                              : null,
                          onChanged: (val) {
                            setState(() => notes = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          child: Text(
                            'הוסף מוצר למערכת',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            RegisterProduct _newProduct = new RegisterProduct(
                                name: name,
                                state: state.toString(),
                                ownerName: ownerName,
                                ownerPhoneNumber: ownerPhoneNumber,
                                pickUpAddress: pickUpAddress,
                                timeForPickUp: timeForPickUp,
                                notes: notes);
                            CollectionReference dbReplies = FirebaseFirestore
                                .instance
                                .collection('Products');
                            FirebaseFirestore.instance
                                .runTransaction((Transaction tx) async {
                              var _result =
                                  await dbReplies.add(_newProduct.toJson());
                            }).then((_result) {
                              showDialogHelper("Product added succesfully");

                              print("Product added succesfully");
                            }).catchError((error) {
                              showDialogHelper("Failed tp add product");

                              print("error");
                            });
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

  void showDialogHelper(String dialogText) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Stack(children: <Widget>[
            Positioned(
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: Text(dialogText),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddProductPage()),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0),
          ]));
        });
  }
}
