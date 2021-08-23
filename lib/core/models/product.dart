class Product {
  final String id;
  final String name;
  final ProductState state;
  final String ownerName;
  final String ownerPhoneNumber;
  final String pickUpAddress;
  final String timeForPickUp;
  final String productPictureURL;
  final String assignedTransportId;
  final String notes;
  final int weight;
  final int length;
  final int width;
  final ProductStatus status;

  Product({
    this.id = '',
    this.name = '',
    this.state = ProductState.unknown,
    this.ownerName = '',
    this.ownerPhoneNumber = '',
    this.pickUpAddress = '',
    this.timeForPickUp = '',
    this.productPictureURL = '',
    this.assignedTransportId = '',
    this.notes = '',
    this.weight = 0,
    this.length = 0,
    this.width = 0,
    this.status = ProductStatus.searching,
  });

  Map<String, dynamic> toJson() => {
        'Product Name': name,
        'State Of Product': state,
        "Owner's Name": ownerName,
        "Owner's Phone Number": ownerPhoneNumber,
        'Pick Up Address': pickUpAddress,
        'Time Span For Pick Up': timeForPickUp,
        'Product Picture URL': productPictureURL,
        'Assigned Transport ID': assignedTransportId,
        'Notes': notes,
        'Weight': weight,
        'Length': length,
        'Width': width,
        'Status Of Product': status,
      };

  static Product productFromDocument(
      Map<dynamic, dynamic> productMap, String id) {
    return Product(
      id: id,
      name: productMap['Product Name'] ?? '',
      state: Product.productStateFromString(productMap['State Of Product']),
      ownerName: productMap["Owner's Name"] ?? '',
      ownerPhoneNumber: productMap["Owner's Phone Number"].toString(),
      pickUpAddress: productMap['Pick Up Address'] ?? '',
      timeForPickUp: productMap['Time Span For Pick Up'] ?? '',
      productPictureURL: productMap['Product Picture URL'] ?? '',
      assignedTransportId: productMap['Assigned Transport ID'] ?? '',
      notes: productMap['Notes'] ?? '',
      weight: productMap['Weight'] ?? 0,
      length: productMap['Length'] ?? 0,
      width: productMap['Width'] ?? 0,
      status: Product.productStatusFromString(productMap["Status Of Product"]),
    );
  }

  static ProductState productStateFromString(String state) {
    ProductState res = ProductState.unknown;
    ProductState.values.forEach((element) => {
          if (element.toString().split('.')[1] == state ||
              element.toString() == state)
            {res = element}
        });

    return res;
  }

  static ProductStatus productStatusFromString(String status) {
    ProductStatus res = ProductStatus.searching;
    ProductStatus.values.forEach((element) => {
          if (element.toString().split('.')[1] == status) {res = element}
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

enum ProductStatus {
  searching,
  waitingToBeDelivered,
  assignToDelivery,
  delivered,
  mock,
}
