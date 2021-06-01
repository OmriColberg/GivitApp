import 'package:flutter/material.dart';

class RegisterProduct {
  String name;
  String state;
  String ownerName;
  int ownerPhoneNumber;
  String pickUpAddress;
  String timeForPickUp;
  String notes;

  RegisterProduct(
      {@required this.name,
      @required this.state,
      @required this.ownerName,
      @required this.ownerPhoneNumber,
      @required this.pickUpAddress,
      @required this.timeForPickUp,
      @required this.notes});

  Map<String, dynamic> toJson() => {
        'name': name,
        'state': state,
        'ownerName': ownerName,
        'ownerPhoneNumber': ownerPhoneNumber,
        'pickUpAddress': pickUpAddress,
        'timeForPickUp': timeForPickUp,
        'notes': notes,
      };
}
