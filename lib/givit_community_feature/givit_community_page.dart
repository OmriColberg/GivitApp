import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/transport.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/services/database.dart';
import 'package:provider/provider.dart';

class GivitCommunityPage extends StatelessWidget {
  final Size size;
  final bool isAdmin;

  GivitCommunityPage({required this.size, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    GivitUser user = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: user.uid);
    return StreamBuilder<QuerySnapshot>(
      stream: db.communityTransportsData,
      builder: (context, snapshotCommunityTransport) {
        if (snapshotCommunityTransport.hasError) {
          print(snapshotCommunityTransport.error);
          return Text('אירעה תקלה, נא לפנות למנהלים');
        }

        if (snapshotCommunityTransport.connectionState ==
            ConnectionState.waiting) {
          return Loading();
        }

        return Container(
          height: size.height,
          color: Colors.blue[100],
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: snapshotCommunityTransport.data!.docs.map(
                (DocumentSnapshot document) {
                  var snapshotData = document.data() as Map;
                  Transport transport = Transport.transportFromDocument(
                      snapshotData, document.id);
                  if (transport.status == TransportStatus.carriedOut) {
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[200],
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  isAdmin
                                      ? InkWell(
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: Colors.red[900],
                                          ),
                                          onTap: () {
                                            showPostDelete(
                                                "אישור מחיקת פוסט ממאגר המידע",
                                                size,
                                                context,
                                                db,
                                                transport);
                                          },
                                        )
                                      : Container(),
                                  Text(transport.sumUp,
                                      style: TextStyle(fontSize: 20)),
                                ],
                              ),
                              Wrap(
                                children: transport.pictures
                                    .map(
                                      (url) => Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Container(
                                          height: 150,
                                          width: 150,
                                          child: Text(''),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(url),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 4)
                      ],
                    );
                  } else {
                    return Container(height: 1);
                  }
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }

  void showPostDelete(String dialogText, Size size, BuildContext context,
      DatabaseService db, Transport transport) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: size.height * 0.5,
          child: AlertDialog(
            title: Text(dialogText),
            content: Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();

                    await db.moveTransportCollection(transport,
                        'Community Transports', 'Storage Transports', {
                      'Current Number Of Carriers':
                          transport.currentNumOfCarriers,
                      'Total Number Of Carriers': transport.totalNumOfCarriers,
                      'Destination Address': transport.destinationAddress,
                      'Pick Up Address': transport.pickUpAddress,
                      'Date For Pick Up': transport.datePickUp.toString(),
                      'Products': transport.products,
                      'Carriers': transport.carriers,
                      'Carriers Phone Numbers': [],
                      'Status Of Transport':
                          TransportStatus.carriedOut.toString().split('.')[1],
                      'Notes': transport.notes,
                      'SumUp': transport.sumUp,
                      'Pictures Folder Name': transport.id,
                    }).then((_result) => null);
                  },
                  child: Text("מחיקה"),
                ),
                SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("ביטול"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
