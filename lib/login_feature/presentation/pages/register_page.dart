import 'package:flutter/material.dart';
import 'package:givit_app/core/shared/constant.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/services/auth.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleView;
  RegisterPage({required this.toggleView});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String fullName = '';
  int phoneNumber = 0;

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
                title: Text('הרשמה לגיביט'),
                actions: <Widget>[
                  TextButton.icon(
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    label: Text(
                      'התחברות',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () => widget.toggleView(),
                  ),
                ],
              ),
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'אי-מייל'),
                        validator: (val) =>
                            val!.isEmpty ? 'הכנס/י אי-מייל' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'סיסמא'),
                        obscureText: true,
                        validator: (val) => val!.length < 6
                            ? 'הכנס סיסמא באורך של לפחות 6 תווים'
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'שם פרטי ומשפחה'),
                        onChanged: (val) {
                          setState(() => fullName = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'מספר טלפון'),
                        validator: (val) => val!.length != 10
                            ? "נא להכניס מספר טלפון חוקי, בעל 10 ספרות ללא מקף"
                            : null,
                        onChanged: (val) {
                          setState(() => phoneNumber = int.parse(val));
                        },
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        child: Text(
                          'הרשמה',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    email, fullName, password, phoneNumber);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'נא לספק אי-מייל חוקי';
                              });
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
          );
  }
}
