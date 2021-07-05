import 'package:cloud_firestore/cloud_firestore.dart';

class GivitUser {
  final String? uid;
  final String? email;
  final String password;
  final String fullName;
  final int phoneNumber;
  final String role;
  final List<String> products;

  GivitUser(
      {this.email = '',
      this.password = '',
      this.fullName = '',
      this.phoneNumber = 0,
      this.role = 'User',
      this.uid = '',
      this.products = const []});

  factory GivitUser.fromFirestorUser(DocumentSnapshot userSnapshout) {
    return GivitUser(
      uid: userSnapshout.id,
      email: userSnapshout['Email'],
      password: userSnapshout['Password'],
      fullName: userSnapshout['Full Name'],
      phoneNumber: userSnapshout['Phone Number'],
      role: userSnapshout['Role'],
      products: List.from(userSnapshout['Products']),
    );
  }
}
