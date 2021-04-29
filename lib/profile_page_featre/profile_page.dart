import 'package:flutter/material.dart';

/// This is the stateless widget that the main application instantiates.
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'This is NOT main ',
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
