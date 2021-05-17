import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class GivitUser {
  final String uid;
  final String email;
  final String password;
  final String fullName;
  final int phoneNumber;

  GivitUser(
      {this.email = '',
      this.password = '',
      this.fullName = '',
      this.phoneNumber = 0,
      this.uid = ''});

  static GivitUser fromJsonToGivitUser(String userString, String uid) {
    String email = userString.substring(
        userString.indexOf("Email") + 8, userString.indexOf("Full") - 3);
    String fullName = userString.substring(
        userString.indexOf("Name") + 7, userString.indexOf("Phone") - 3);
    String phoneNumber = userString.substring(
        userString.indexOf("Number") + 8, userString.indexOf("Password") - 3);
    String password = userString.substring(
        userString.indexOf("Password") + 11, userString.length - 2);

    return GivitUser(
        uid: uid,
        email: email,
        fullName: fullName,
        phoneNumber: int.parse(phoneNumber),
        password: password);

    // userInfo.forEach((element) {
    //   element = element.toString().replaceRange(
    //       element.toString().indexOf("\""), element.toString().length, "");
    //   print("string: $element");
    // });
  }
}
