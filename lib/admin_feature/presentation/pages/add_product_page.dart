import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
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
  final _formKey = GlobalKey<FormState>();

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
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'שם המוצר'),
                      //validator: (val) => val!.isEmpty ? 'הכנס שם מוצר' : null,
                      onChanged: (val) {
                        setState(() => name = val);
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
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
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    child: Text(
                      'הוסף מוצר למערכת',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        db.addProduct(name: name, notes: notes).then((_result) {
                          print(
                              'This is the ID of the product that just added: $_result');
                          showDialogHelper("המוצר התווסף בהצלחה", widget.size);
                        }).catchError((error) {
                          showDialogHelper(
                              "קרתה תקלה, נסה שוב ($error)", widget.size);
                        });
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
