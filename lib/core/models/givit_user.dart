import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:givit_app/core/models/product.dart';

class GivitUser {
  final String uid;
  final String email;
  final String password;
  final String fullName;
  final int phoneNumber;
  final String role;
  List<String> products;

  GivitUser({
    this.email = '',
    this.password = '',
    this.fullName = '',
    this.phoneNumber = 0,
    this.role = '',
    this.uid = '',
    this.products,
  });

  factory GivitUser.fromFirestorUser(DocumentSnapshot userSnapshot) {
    print("check:");
    print(userSnapshot);
    return GivitUser(
      uid: userSnapshot.id,
      email: userSnapshot['Email'],
      password: userSnapshot['Password'],
      fullName: userSnapshot['Full Name'],
      phoneNumber: userSnapshot['Phone Number'],
      role: userSnapshot['Role'],
      products: List.from(userSnapshot['Products']),
    );
  }
}
