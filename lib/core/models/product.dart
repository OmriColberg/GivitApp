class Product {
  final String id;
  final String name;
  final ProductState state;
  final String ownerName;
  final String ownerPhoneNumber;
  final String pickUpAddress;
  final String timeForPickUp;
  final String notes;

  Product(
      {this.id = '',
      this.name = '',
      this.state = ProductState.unknown,
      this.ownerName = '',
      this.ownerPhoneNumber = '',
      this.pickUpAddress = '',
      this.timeForPickUp = '',
      this.notes = ''});

  static Product productFromDocument(
      Map<dynamic, dynamic> productMap, String id) {
    return Product(
      id: id,
      name: productMap['Product Name'],
      state: Product.productStateFromString(productMap['State Of Product']),
      ownerName: productMap["Owner's Name"],
      ownerPhoneNumber: productMap["Owner's Phone Number"],
      pickUpAddress: productMap['Pick Up Address'],
      timeForPickUp: productMap['Time Span For Pick Up'],
      notes: productMap['Notes'],
    );
  }

  static ProductState productStateFromString(String state) {
    ProductState res;
    ProductState.values.forEach((element) => {
          if (element.toString() == state) {res = element}
        });

    return res;
  }
}

enum ProductState {
  brandNew,
  likeNew,
  used,
  unknown,
}
