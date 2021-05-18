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

  GivitUser _givitUserDataFromSnapshot(DocumentSnapshot snapshot) {
    var snapshotData = snapshot.data() as Map;
    return GivitUser(
      uid: uid,
      email: snapshotData['Email'],
      fullName: snapshotData['Full Name'],
      phoneNumber: snapshotData['Phone Number'],
    );
  }

  Stream<GivitUser> get userData {
    return userCollection.doc(uid).snapshots().map(_givitUserDataFromSnapshot);
  }
}
