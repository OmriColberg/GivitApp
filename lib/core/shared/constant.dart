import 'package:flutter/material.dart';

String defaultProfileUrl =
    'https://firebasestorage.googleapis.com/v0/b/givitapp-4c707.appspot.com/o/default_profile_pic.png?alt=media&token=6c3c74ce-e55b-4137-af5a-5d587385eb66';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2.0),
  ),
);
