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
}

enum ProductState {
  brandNew,
  likeNew,
  used,
  unknown,
}
