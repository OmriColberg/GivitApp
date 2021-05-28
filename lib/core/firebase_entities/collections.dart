import 'package:cloud_firestore/cloud_firestore.dart';

class Collection {
  CollectionReference _ref;
  CollectionReference get collectionReference => this._ref;
}

class UsersCollection extends Collection {
  UsersCollection() {
    this._ref = FirebaseFirestore.instance.collection('Users');
  }
}
