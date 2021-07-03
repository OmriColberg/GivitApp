import 'package:flutter/material.dart';
import 'package:givit_app/login_feature/presentation/pages/register_page.dart';
import 'package:givit_app/login_feature/presentation/pages/login_page.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn
        ? LoginPage(toggleView: toggleView)
        : RegisterPage(toggleView: toggleView);
  }
}
