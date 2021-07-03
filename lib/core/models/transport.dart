import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:givit_app/core/models/product.dart';
import 'givit_user.dart';

class Transport {
  final String id;
  final List<GivitUser> carriers;
  final List<Product> products;
  final DateTime datePickUp;
  final String destinationAddress;
  final String notes;
  final Timestamp timestamp;

  Transport({
    this.id = '',
    this.destinationAddress = '',
    this.notes = '',
    this.carriers = const [],
    this.products = const [],
    required this.datePickUp,
    required this.timestamp,
  });

  static Transport transportFromDocument(
      Map<dynamic, dynamic> trasnportMap, String id) {
    //this.timestamp.
    return Transport(
      id: id,
      datePickUp: trasnportMap['Date For Pick Up'].toDate(),
      notes: trasnportMap['Notes'],
      timestamp: Timestamp.now(),
    );
  }
}
