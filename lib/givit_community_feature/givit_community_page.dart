import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/models/transport.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/services/database.dart';
import 'package:provider/provider.dart';

/// This is the stateless widget that the main application instantiates.
class GivitCommunityPage extends StatefulWidget {
  final Size size;

  GivitCommunityPage({required this.size});

  @override
  _GivitCommunityPageState createState() => _GivitCommunityPageState();
}

class _GivitCommunityPageState extends State<GivitCommunityPage> {
  @override
  Widget build(BuildContext context) {
    GivitUser user = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: user.uid);
    return StreamBuilder<QuerySnapshot>(
      stream: db.transportsData,
      builder: (context, snapshotTransport) {
        if (snapshotTransport.hasError) {
          print(snapshotTransport.error);
          return Text(snapshotTransport.error.toString() +
              'אירעה תקלה, נא לפנות למנהלים');
        }

        if (snapshotTransport.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        return Container(
          height: widget.size.height,
          color: Colors.blue[100],
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: snapshotTransport.data!.docs.map(
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
                              Text(transport.sumUp,
                                  style: TextStyle(fontSize: 20)),
                              Wrap(
                                children: transport.pictures
                                    .map(
                                      (url) => Container(
                                        height: 150,
                                        width: 150,
                                        child: Text(''),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(url),
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
}
