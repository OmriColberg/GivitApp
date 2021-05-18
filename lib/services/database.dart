import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/models/givit_user.dart';
import 'package:givit_app/models/product.dart';

class DatabaseService {
  final String uid;
  DatabaseService({@required this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('Products');
  final CollectionReference transportsCollection =
      FirebaseFirestore.instance.collection('Transports');

  Future<void> updateGivitUserData(
      String email, String fullName, String password, int phoneNumber) async {
    return await usersCollection.doc(uid).set({
      'Email': email,
      'Full Name': fullName,
      'Password': password,
      'Phone Number': phoneNumber,
    });
  }

  Future<void> updateProductData(
      {String id,
      String name,
      ProductState state,
      String ownerName,
      String ownerPhoneNumber,
      String pickUpAddress,
      String timeForPickUp,
      String notes}) async {
    final String _id = id ?? productsCollection.doc().id;
    return await productsCollection.doc(_id).set({
      'Notes': notes,
      'Product Name': name,
      'State Of Product': state.toString(),
      "Owner's Name": ownerName,
      "Owner's Phone Number": ownerPhoneNumber,
      'Time Span For Pick Up': timeForPickUp,
      'Pick Up Address': pickUpAddress,
    });
  }

  Product _productsDataFromSnapshot(QuerySnapshot snapshot) {
    return Product();
  }

  Stream<Product> get producstData {
    return productsCollection.snapshots().map(_productsDataFromSnapshot);
  }

  GivitUser _givitUserDataFromSnapshot(DocumentSnapshot snapshot) {
    var snapshotData = snapshot.data() as Map;
    return GivitUser(
      uid: uid,
      email: snapshotData['Email'],
      password: snapshotData['Password'],
      fullName: snapshotData['Full Name'],
      phoneNumber: snapshotData['Phone Number'],
    );
  }

  Stream<GivitUser> get userData {
    return usersCollection.doc(uid).snapshots().map(_givitUserDataFromSnapshot);
  }
}
