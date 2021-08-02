import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/models/transport.dart';
import 'package:givit_app/services/database.dart';
import 'package:provider/provider.dart';

const String defaultProfileUrl =
    'https://firebasestorage.googleapis.com/v0/b/givitapp-4c707.appspot.com/o/default_profile_pic.png?alt=media&token=a9be15ee-dc72-41a0-9ff9-a3427fbc2b47';

const String defaultFurnitureUrl =
    'https://firebasestorage.googleapis.com/v0/b/givitapp-4c707.appspot.com/o/default_furniture_pic.jpeg?alt=media&token=a5cf7296-09cd-4df3-876f-7e1822e2b1b1';

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
