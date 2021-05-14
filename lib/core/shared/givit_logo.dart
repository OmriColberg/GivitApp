import 'package:flutter/material.dart';

class GivitLogo extends StatelessWidget {
  final Size size;
  GivitLogo({this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.8,
      height: size.height * 0.8,
      child: Image.asset('lib/core/assets/givit-white.png'),
    );
  }
}
