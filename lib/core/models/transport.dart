import 'package:givit_app/core/models/product.dart';
import 'givit_user.dart';

class Transport {
  final List<GivitUser> carriers;
  final List<Product> products;
  final DateTime datePickUp;
  final String destinationAddress;
  final String notes;

  Transport({
    this.destinationAddress = '',
    this.notes = '',
    this.carriers = const [],
    this.products = const [],
    this.datePickUp,
  });
}
