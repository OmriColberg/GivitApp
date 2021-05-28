import 'package:givit_app/core/models/product.dart';
import 'givit_user.dart';

class Transport {
  final String id;
  final List<GivitUser> carriers;
  final List<Product> products;
  final DateTime datePickUp;
  final String destinationAddress;
  final String notes;

  Transport({
    this.id = '',
    this.destinationAddress = '',
    this.notes = '',
    this.carriers = const [],
    this.products = const [],
    this.datePickUp,
  });

  static Transport transportFromDocument(
      Map<dynamic, dynamic> trasnportMap, String id) {
    return Transport(id: id, notes: trasnportMap['Notes']);
  }
}
