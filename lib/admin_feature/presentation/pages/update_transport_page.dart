import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/product.dart';
import 'package:givit_app/core/shared/assign_card_product.dart';
import 'package:givit_app/core/shared/constant.dart';
import 'package:givit_app/services/database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:ui' as ui;

class UpdateTransportPage extends StatefulWidget {
  final Size size;
  final int totalNumOfCarriers;
  final String destinationAddress;
  final String pickUpAddress;
  final String notes;
  final DateTime datePickUp;
  final String transportId;
  UpdateTransportPage(
      {required this.size,
      required this.totalNumOfCarriers,
      required this.destinationAddress,
      required this.pickUpAddress,
      required this.notes,
      required this.datePickUp,
      required this.transportId});

  @override
  _UpdateTransportPageState createState() => _UpdateTransportPageState();
}

class _UpdateTransportPageState extends State<UpdateTransportPage> {
  void initState() {
    super.initState();
    totalNumOfCarriers = widget.totalNumOfCarriers;
    destinationAddress = widget.destinationAddress;
    pickUpAddress = widget.pickUpAddress;
    notes = widget.notes;
    datePickUp = widget.datePickUp;
  }

  final _formKey = GlobalKey<FormState>();
  String error = '';

  late int totalNumOfCarriers;
  late String destinationAddress;
  late String pickUpAddress;
  late String notes;
  late DateTime datePickUp;

  @override
  Widget build(BuildContext context) {
    GivitUser user = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: user.uid);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          elevation: 0.0,
          title: Text('    עדכון הובלה קיימת '),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            color: Colors.blue[100],
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: TextFormField(
                      initialValue: totalNumOfCarriers.toString(),
                      decoration: textInputDecoration.copyWith(
                          hintText: 'מספר מובילים'),
                      validator: (val) =>
                          val!.isEmpty ? 'הכנס מספר מובילים' : null,
                      onChanged: (val) {
                        setState(() => totalNumOfCarriers = int.parse(val));
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: TextFormField(
                      initialValue: destinationAddress,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'כתובת יעד'),
                      validator: (val) =>
                          val!.isEmpty ? 'הכנס כתובת יעד' : null,
                      onChanged: (val) {
                        setState(() => destinationAddress = val);
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: TextFormField(
                      initialValue: pickUpAddress,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'כתובת התחלה'),
                      validator: (val) =>
                          val!.isEmpty ? 'הכנס כתובת התחלה' : null,
                      onChanged: (val) {
                        setState(() => pickUpAddress = val);
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: TextFormField(
                      initialValue: notes,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'הערות'),
                      onChanged: (val) {
                        setState(() => notes = val);
                      },
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: ui.TextDirection.rtl,
                    children: [
                      Text(
                        "\t:בחר תאריך ושעת הובלה",
                        style: TextStyle(fontSize: 18),
                      ),
                      GestureDetector(
                        child: Icon(Icons.calendar_today_outlined,
                            color: Colors.black),
                        onTap: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day, 0),
                              maxTime: DateTime(
                                  DateTime.now().year + 3, 12, 31, 23, 59),
                              onChanged: (date) {}, onConfirm: (date) {
                            setState(() => datePickUp = date);
                          }, currentTime: datePickUp, locale: LocaleType.en);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: ui.TextDirection.rtl,
                    children: [
                      isDatePicked(datePickUp)
                          ? Text(
                              "תאריך הובלה הנבחר: ${datePickUp.day.toString().padLeft(2, '0')}-${datePickUp.month.toString().padLeft(2, '0')}-${datePickUp.year.toString()} בשעה ${datePickUp.hour.toString().padLeft(2, '0')}:${datePickUp.minute.toString()}",
                              style: TextStyle(fontSize: 14),
                            )
                          : Text(
                              "תאריך הובלה לא נבחר",
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  ElevatedButton(
                    child: Text(
                      'עדכון הובלה',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await db.updateTransportFields(
                            'Transports', widget.transportId, {
                          'Date For Pick Up': DateFormat('yyyy-MM-dd HH:mm')
                              .format(datePickUp)
                              .toString(),
                          'Total Number Of Carriers': totalNumOfCarriers,
                          'Destination Address': destinationAddress,
                          'Pick Up Address': pickUpAddress,
                          'Notes': notes,
                        });
                        showDialogHelper('ההובלה עודכנה בהצלחה', widget.size);
                        _formKey.currentState!.reset();
                      }
                    },
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showDialogHelper(String dialogText, Size size) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: size.height * 0.5,
          child: AlertDialog(
            title: Text(dialogText),
            content: Stack(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("לחזרה"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

AssignCardProduct createDeliveryAssignFromProductSnapshot(
    Product product, Size size) {
  return AssignCardProduct(
    title: product.name,
    body: product.notes,
    schedule: 'לשיבוץ חיפוש',
    type: CardType.admin,
    product: product,
    personalProducts: [],
    size: size,
    isAdmin: true,
  );
}

bool isDatePicked(DateTime datePicked) {
  return !(datePicked.year == DateTime.now().year &&
      datePicked.month == DateTime.now().month &&
      datePicked.day == DateTime.now().day &&
      datePicked.hour == DateTime.now().hour);
}
