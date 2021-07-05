import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';

class DatabaseService {
  final String? uid;
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
      'Products': [],
      'Transports': [],
      'Role': 'User',
    });
  }

  Future<void> updateGivitUserData(
      String? email, String fullName, String password, int phoneNumber) async {
    return await usersCollection.doc(uid).update({
      'Email': email,
      'Full Name': fullName,
      'Password': password,
      'Phone Number': phoneNumber,
    });
  }

  Future<void> addTransportToGivitUser(String id) async {
    DocumentReference<Object?> doc = usersCollection.doc(uid);
    return await doc.update({
      "Transports": FieldValue.arrayUnion(['$id'])
    });
  }

  Future<void> addProductToGivitUser(String id) async {
    DocumentReference<Object?> doc = usersCollection.doc(uid);
    return await doc.update({
      "Products": FieldValue.arrayUnion(['$id'])
    });
  }

  Stream<QuerySnapshot<Object?>> get transportsData {
    return transportsCollection.snapshots();
  }

  Future<void> addProductData({
    String? name,
    String? notes,
  }) async {
    return await productsCollection.add({
      'Notes': notes,
      'Product Name': name,
      'State Of Product': ProductState.unknown.toString().split('.')[1],
      "Owner's Name": '',
      "Owner's Phone Number": 0,
      'Time Span For Pick Up': '',
      'Pick Up Address': '',
      'Weight': 0,
      'Length': 0,
      'Width': 0,
      'Status Of Product': ProductStatus.searching.toString().split('.')[1],
    }).then((value) => value.id);
  }

  Future<void> updateProductData({
    String? id,
    String? ownerName,
    ProductState? state,
    String? ownerPhoneNumber,
    String? pickUpAddress,
    String? timeForPickUp,
    String? notes,
    int? weight,
    int? length,
    int? width,
    ProductStatus? status = ProductStatus.waitingToBeDelivered,
  }) async {
    return await productsCollection.doc(id).update({
      "Owner's Name": ownerName,
      'State Of Product': state.toString().split('.')[1],
      "Owner's Phone Number": ownerPhoneNumber,
      'Pick Up Address': pickUpAddress,
      'Time Span For Pick Up': timeForPickUp,
      'Weight': weight,
      'Length': length,
      'Width': width,
      'Notes': notes,
      'Status Of Product': status.toString().split('.')[1],
    });
  }

  Future<void> deleteProductFromProductList(String id) async {
    return await productsCollection
        .doc(id)
        .delete()
        .then((_) => print('$id deleted successfuly from products list'))
        .catchError((onError) => print("Error removing document: $onError"));
  }

  Future<void> deleteProductFromUserList(
      String id, List<String> products) async {
    return await usersCollection
        .doc(uid)
        .update({"Products": products})
        .then((_) => print('$id successfuly removed from user'))
        .catchError((onError) => print("Error removing document: $onError"));
  }

  Stream<QuerySnapshot<Object?>> get producstData {
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
      transports: List.from(snapshotData['Transports']),
    );
  }

  Stream<GivitUser> get userData {
    return usersCollection.doc(uid).snapshots().map(_givitUserDataFromSnapshot);
  }
}
