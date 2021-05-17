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

  GivitUser _userDataFromSnapshot(DocumentSnapshot<GivitUser> snapshot) {
    return GivitUser(
      uid: uid,
      email: snapshot.data().email,
      fullName: snapshot.data().fullName,
      phoneNumber: snapshot.data().phoneNumber,
    );
  }

  Stream<GivitUser> get userData {
    print('before getter');
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
