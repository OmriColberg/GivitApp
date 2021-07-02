import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('Products');
  final CollectionReference transportsCollection =
      FirebaseFirestore.instance.collection('Transports');

  Future<void> createGivitUserData(
      String email, String fullName, String password, int phoneNumber) async {
    return await usersCollection.doc(uid).set({
      'Email': email,
      'Full Name': fullName,
      'Password': password,
      'Phone Number': phoneNumber,
    });
  }

  Future<void> updateGivitUserData(
      String email, String fullName, String password, int phoneNumber) async {
    return await usersCollection.doc(uid).update({
      'Email': email,
      'Full Name': fullName,
      'Password': password,
      'Phone Number': phoneNumber,
    });
  }

  Future<void> addProductToGivitUser(String id) async {
    DocumentReference<Object> doc = usersCollection.doc(uid);
    print(doc.toString());
    print(uid);
    print(id);

    return await doc.update({
      "Products": FieldValue.arrayUnion(['$id']),
    }).then((e) {
      print('added successfuly');
    }).catchError((onError) {
      print("not good");
    });
  }

  Stream<QuerySnapshot<Object>> get transportsData {
    return transportsCollection.snapshots();
  }

  Future<void> addProductData(
      {String id,
      String name,
      ProductState state,
      String ownerName,
      String ownerPhoneNumber,
      String pickUpAddress,
      String timeForPickUp,
      String notes}) async {
    return await productsCollection.add({
      'Notes': notes,
      'Product Name': name,
      'State Of Product': state.toString(),
      "Owner's Name": ownerName,
      "Owner's Phone Number": ownerPhoneNumber,
      'Time Span For Pick Up': timeForPickUp,
      'Pick Up Address': pickUpAddress,
    }).then((value) => value.id);
  }

  Stream<QuerySnapshot<Object>> get producstData {
    return productsCollection.snapshots();
  }

  GivitUser _givitUserDataFromSnapshot(DocumentSnapshot snapshot) {
    var snapshotData = snapshot.data() as Map;
    return GivitUser(
      uid: uid,
      email: snapshotData['Email'],
      password: snapshotData['Password'],
      fullName: snapshotData['Full Name'],
      phoneNumber: snapshotData['Phone Number'],
      role: snapshotData['Role'],
      products: List.from(snapshotData['Products']),
    );
  }

  Stream<GivitUser> get userData {
    return usersCollection.doc(uid).snapshots().map(_givitUserDataFromSnapshot);
  }
}
