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

  Map<String, dynamic> toJson() => {
        'Product Name': name,
        'State Of Product': state,
        "Owner's Name": ownerName,
        "Owner's Phone Number": ownerPhoneNumber,
        'Pick Up Address': pickUpAddress,
        'Time Span For Pick Up': timeForPickUp,
        'Notes': notes,
      };

  static Product productFromDocument(
      Map<dynamic, dynamic> productMap, String id) {
    return Product(
      id: id,
      name: productMap['Product Name'],
      state: Product.productStateFromString(productMap['State Of Product']),
      ownerName: productMap["Owner's Name"],
      ownerPhoneNumber: productMap["Owner's Phone Number"].toString(),
      pickUpAddress: productMap['Pick Up Address'],
      timeForPickUp: productMap['Time Span For Pick Up'],
      notes: productMap['Notes'],
    );
  }

  static ProductState productStateFromString(String state) {
    ProductState res = ProductState.unknown;
    ProductState.values.forEach((element) => {
          if (Product.hebrewFromEnum(element) == state ||
              element.toString() == state)
            {res = element}
        });

    return res;
  }

  static String hebrewFromEnum(ProductState state) {
    switch (state) {
      case ProductState.brandNew:
        {
          return 'חדש';
        }
      case ProductState.likeNew:
        {
          return 'כמו חדש';
        }
      case ProductState.used:
        {
          return 'משומש';
        }
      default:
        {
          return 'לא ידוע';
        }
    }
  }
}

enum ProductState {
  brandNew,
  likeNew,
  used,
  unknown,
}
