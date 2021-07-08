import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/shared/constant.dart';
import 'package:givit_app/services/database.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  final Size size;
  AddProductPage({required this.size});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  String error = '';

  String name = '';
  String notes = '';

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
          title: Text('הוספת מוצר'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                  decoration:
                      textInputDecoration.copyWith(hintText: 'שם המוצר'),
                  validator: (val) => val!.isEmpty ? 'הכנס שם מוצר' : null,
                  onChanged: (val) {
                    setState(() => name = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration:
                      textInputDecoration.copyWith(hintText: 'הערות נוספות'),
                  /*validator: (val) => val.length != 10
                              ? "הכנס הערות על המוצר או איסופו"
                              : null,*/
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
                    db.addProductData(name: name, notes: notes).then((_result) {
                      showDialogHelper(
                          "Product added succesfully", widget.size);
                    }).catchError((error) {
                      showDialogHelper("Failed tp add product", widget.size);
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
    );
  }

  void showDialogHelper(String dialogText, Size size) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: size.height * 0.5,
            child: AlertDialog(
                title: Text("המוצר הוסף בהצלחה"),
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
