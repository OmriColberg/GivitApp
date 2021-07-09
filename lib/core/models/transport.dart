import 'package:cloud_firestore/cloud_firestore.dart';

class Transport {
  final String id;
  final int currentNumOfCarriers;
  final int totalNumOfCarriers;
  final List<String> carriers;
  final List<String> products;
  final DateTime datePickUp;
  final String pickUpAddress;
  final String destinationAddress;
  final String notes;

  Transport({
    this.id = '',
    this.currentNumOfCarriers = 0,
    this.totalNumOfCarriers = 0,
    this.destinationAddress = '',
    this.pickUpAddress = '',
    this.notes = '',
    this.carriers = const [],
    this.products = const [],
    required this.datePickUp,
  });

  static Transport transportFromDocument(
      Map<dynamic, dynamic> trasnportMap, String id) {
    return Transport(
      id: id,
      currentNumOfCarriers: trasnportMap['Current Number Of Carriers'] ?? 0,
      totalNumOfCarriers: trasnportMap['Total Number Of Carriers'] ?? 0,
      destinationAddress: trasnportMap['Destination Address'] ?? '',
      pickUpAddress: trasnportMap['Pick Up Address'] ?? '',
      datePickUp: DateTime.parse(trasnportMap['Date For Pick Up']),
      carriers: List.from(trasnportMap['Carriers'])
      // .isEmpty
      //     ? []
      //     : List.from(trasnportMap['Carriers'])
      ,
      products: List.from(trasnportMap['Products'])
      // .isEmpty
      //     ? []
      //     : List.from(trasnportMap['Products'])
      ,
      notes: trasnportMap['Notes'] ?? '',
    );
  }
}
