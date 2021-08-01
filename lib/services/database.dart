import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/models/transport.dart';
import 'package:givit_app/core/shared/constant.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference givitUsersCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('Products');
  final CollectionReference transportsCollection =
      FirebaseFirestore.instance.collection('Transports');

  Future<void> addGivitUser(
      String email, String fullName, String password, int phoneNumber) async {
    return await givitUsersCollection.doc(uid).set({
      'Email': email,
      'Full Name': fullName,
      'Password': password,
      'Phone Number': phoneNumber,
      'Profile Picture URL': defaultProfileUrl,
      'Products': [],
      'Transports': [],
      'Role': 'User',
    });
  }

  Future<void> updateAssignProducts(
      List<String> products, Map<String, Object?> data) async {
    Set mySet = products.toSet();
    await productsCollection.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((product) {
            if (mySet.contains(product.id)) {
              updateProductFields(product.id, data);
            }
          })
        });
  }

  Future<void> updateAssignGivitUsers(
      List<String> givitUsers, Map<String, Object?> data) async {
    Set mySet = givitUsers.toSet();
    await givitUsersCollection.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((givitUser) {
            if (mySet.contains(givitUser.id)) {
              updateGivitUserFields(data);
            }
          })
        });
  }

  Future<Transport> getTransportByID(String id) async {
    return await transportsCollection
        .doc(id)
        .get()
        .then((DocumentSnapshot<Object?> document) {
      var snapshotData = document.data() as Map;
      return Transport.transportFromDocument(snapshotData, document.id);
    });
  }

  Future<void> updateGivitUserFields(Map<String, Object?> data) async {
    return await givitUsersCollection.doc(uid).update(data);
  }

  Future<void> updateProductFields(String id, Map<String, Object?> data) async {
    return await productsCollection.doc(id).update(data);
  }

  Future<void> updateTransportFields(
      String id, Map<String, Object?> data) async {
    return await transportsCollection.doc(id).update(data);
  }

  Future<String> addTransport({
    int? totalNumOfCarriers,
    String? destinationAddress,
    String? pickUpAddress,
    String? notes,
    List<String>? products,
    DateTime? datePickUp,
  }) async {
    return await transportsCollection.add({
      'Current Number Of Carriers': 0,
      'Total Number Of Carriers': totalNumOfCarriers ?? 0,
      'Destination Address': destinationAddress ?? '',
      'Pick Up Address': pickUpAddress ?? '',
      'Date For Pick Up':
          DateFormat('yyyy-MM-dd hh:mm').format(datePickUp!).toString(),
      'Products': products ?? [],
      'Carriers': [],
      'Status Of Transport':
          TransportStatus.waitingForVolunteers.toString().split('.')[1],
      'Pictures': [],
      'Notes': notes ?? '',
      'SumUp': '',
    }).then((value) => value.id);
  }

  Stream<QuerySnapshot<Object?>> get transportsData {
    return transportsCollection.snapshots();
  }

  Future<String> addProduct({String? name, String? notes}) async {
    Reference ref =
        FirebaseStorage.instance.ref().child("/default_furniture_pic.jpg");
    String url = (await ref.getDownloadURL()).toString();
    return await productsCollection.add({
      'Notes': notes,
      'Product Name': name,
      'State Of Product': ProductState.unknown.toString().split('.')[1],
      "Owner's Name": '',
      "Owner's Phone Number": 0,
      'Time Span For Pick Up': '',
      'Pick Up Address': '',
      'Product Picture URL': url,
      'Assigned Transport ID': '',
      'Weight': 0,
      'Length': 0,
      'Width': 0,
      'Status Of Product': ProductStatus.searching.toString().split('.')[1],
    }).then((value) => value.id);
  }

  Future<void> deleteProductFromGivitUserList(String productId) async {
    return await givitUsersCollection
        .get()
        .then((QuerySnapshot<Object?> querySnapshot) => {
              querySnapshot.docs.forEach((document) {
                GivitUser givitUser = GivitUser.fromFirestorUser(document);
                if (givitUser.products.contains(productId)) {
                  updateGivitUserFields({
                    "Products": FieldValue.arrayRemove(['$productId'])
                  });
                }
              })
            });
  }

  Future<void> deleteProductFromTransportList(
      String productId, String transportId) async {
    await transportsCollection.doc(transportId).update({
      "Carriers": FieldValue.arrayRemove(['$productId'])
    });
  }

  Future<void> deleteProductFromProductList(String id) async {
    return await productsCollection.doc(id).delete();
  }

  Future<void> deleteTransportFromTransportList(String id) async {
    return await transportsCollection.doc(id).delete();
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
      profilePictureURL: snapshotData['Profile Picture URL'],
      role: snapshotData['Role'],
      products: List.from(snapshotData['Products']),
      transports: List.from(snapshotData['Transports']),
    );
  }

  Stream<GivitUser> get givitUserData {
    return givitUsersCollection
        .doc(uid)
        .snapshots()
        .map(_givitUserDataFromSnapshot);
  }

  Stream<QuerySnapshot<Object?>> get givitUsersData {
    return givitUsersCollection.snapshots();
  }
}
