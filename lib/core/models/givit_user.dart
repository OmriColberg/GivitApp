import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io' as Io;

class GivitUser {
  final String? uid;
  final String? email;
  final String password;
  final String fullName;
  final int phoneNumber;
<<<<<<< Updated upstream
  final String profilePictureURL;
=======
  final String profilePicture64;
>>>>>>> Stashed changes
  final String role;
  final List<String> products;
  final List<String> transports;

  GivitUser({
    this.email = '',
    this.password = '',
    this.fullName = '',
    this.phoneNumber = 0,
    this.role = 'User',
    this.profilePictureURL = '',
    this.uid = '',
    this.profilePicture64 = '',
    this.products = const [],
    this.transports = const [],
  });

  factory GivitUser.fromFirestorUser(DocumentSnapshot userSnapshot) {
    return GivitUser(
      uid: userSnapshot.id,
      email: userSnapshot['Email'],
      password: userSnapshot['Password'],
      fullName: userSnapshot['Full Name'],
      phoneNumber: userSnapshot['Phone Number'],
<<<<<<< Updated upstream
      profilePictureURL: userSnapshot['Profile Picture URL'],
=======
      profilePicture64: userSnapshot['Profile Picture'],
>>>>>>> Stashed changes
      role: userSnapshot['Role'],
      products: List.from(userSnapshot['Products']),
      transports: List.from(userSnapshot['Transports']),
    );
  }
}
