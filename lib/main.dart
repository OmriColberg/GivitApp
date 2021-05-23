import 'package:flutter/material.dart';
import 'package:givit_app/givit_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:givit_app/core/di/di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //di.setup();
  runApp(GivitApp());
}
