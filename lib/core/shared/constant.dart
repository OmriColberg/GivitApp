import 'package:flutter/material.dart';

const String defaultProfileUrl =
    'https://firebasestorage.googleapis.com/v0/b/givit-68003.appspot.com/o/default_profile_pic.png?alt=media&token=1f5f17f7-702e-4573-a415-313146d43714';

const String defaultFurnitureUrl =
    'https://firebasestorage.googleapis.com/v0/b/givit-68003.appspot.com/o/default_furniture_pic.jpeg?alt=media&token=bc94060d-ab37-4582-afbd-c8aed8f92653';

const String CONFIRMATION_CODE = 'givitrule';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
  ),
);
