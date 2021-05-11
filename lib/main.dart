import 'package:flutter/material.dart';
import 'package:givit_app/givit_app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  //runApp(MainMenu());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('main');
  runApp(GivitApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.1,
      )),
    );
  }
}
