import 'package:flutter/material.dart';
import 'package:givit_app/core/shared/constant.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/services/auth.dart';

class LoginPage extends StatefulWidget {
  final Function toggleView;
  LoginPage({required this.toggleView});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  String email = '';
  String password = '';

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
                title: Text('התחברות לגיביט'),
                actions: <Widget>[
                  TextButton.icon(
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    label: Text(
                      'הרשמה',
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
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'אי-מייל'),
                          validator: (val) =>
                              val!.isEmpty ? 'הכנס אי-מייל' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          obscureText: true,
                          decoration:
                              textInputDecoration.copyWith(hintText: 'סיסמא'),
                          validator: (val) => val!.length < 6
                              ? 'הכנס סיסמא באורך של לפחות 6 תווים'
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                          child: Text(
                            'התחברות',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error =
                                      'לא ניתן להתחבר עם אמצעי הזיהוי שסופקו';
                                });
                              }
                            }
                          }),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
