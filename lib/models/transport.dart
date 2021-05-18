import 'package:givit_app/models/givit_user.dart';
import 'package:givit_app/models/product.dart';

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
