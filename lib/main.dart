import 'package:flutter/material.dart';
import 'package:givit_app/givit_app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GivitApp());
}
