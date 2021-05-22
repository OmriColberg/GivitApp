import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:givit_app/core/di/di.dart';
import 'package:givit_app/core/models/givit_user.dart';

class LoginProvider with ChangeNotifier {
  final FirebaseAuth _auth;
  final GivitUser currentLoggedInUser;

  LoginProvider()
      : _auth = FirebaseAuth.instance,
        currentLoggedInUser = getIt();
}
