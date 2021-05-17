import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/models/givit_user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({@required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<void> updateGivitUserData(
      String email, String fullName, String password, int phoneNumber) async {
    return await userCollection.doc(uid).set({
      'Email': email,
      'Full Name': fullName,
      'Password': password,
      'Phone Number': phoneNumber,
    });
  }

  Future<GivitUser> getGivitUser(String uid) async {
    return await userCollection.doc(uid).get().then((user) => user.data());
  }

  GivitUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    final dat = snapshot.data();
    print("!!!!!!!!!! type:${dat.runtimeType} || value:$dat");
    final userString = jsonEncode(dat);
    print("@@@@@@@@@@ type:${userString.runtimeType} || value:$userString");

    // String splitString = "\":\"";

    String email = userString.substring(
        userString.indexOf("Email") + 8, userString.indexOf("Full") - 3);
    String fullName = userString.substring(
        userString.indexOf("Name") + 7, userString.indexOf("Phone") - 3);
    String phoneNumber = userString.substring(
        userString.indexOf("Number") + 8, userString.indexOf("Password") - 3);
    String password = userString.substring(
        userString.indexOf("Password") + 11, userString.length - 2);
    print(
        "|||| ${email} |||| ${fullName} |||| ${phoneNumber} |||| ${password}");

    // GivitUser user = GivitUser.fromJsonToGivitUser(userString);
    // print("%%%%%%% $user");

    return GivitUser(
        uid: uid,
        email: email,
        fullName: fullName,
        phoneNumber: int.parse(phoneNumber),
        password: password);
    // return GivitUser(
    //   uid: uid,
    //   email: snapshot.data()['Email'],
    //   fullName: snapshot.data()['Full Name'],
    //   phoneNumber: snapshot.data()['Phone Number'],
    // );
  }

  Stream<GivitUser> get userData {
    print('before getter');
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
