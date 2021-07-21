import 'package:cloud_firestore/cloud_firestore.dart';

class GivitUser {
  final String? uid;
  final String? email;
  final String password;
  final String fullName;
  final int phoneNumber;
  final String profilePictureURL;
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
      profilePictureURL: userSnapshot['Profile Picture URL'],
      role: userSnapshot['Role'],
      products: List.from(userSnapshot['Products']),
      transports: List.from(userSnapshot['Transports']),
    );
  }
}
