import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gallery_view/gallery_view.dart';
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
          return Text('אירעה תקלה, נא לפנות למנהלים');
        }

        if (snapshotTransport.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        return Container(
          height: widget.size.height,
          color: Colors.blue[100],
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: snapshotTransport.data!.docs.map(
              (DocumentSnapshot document) {
                var snapshotData = document.data() as Map;
                Transport transport =
                    Transport.transportFromDocument(snapshotData, document.id);
                if (transport.status == TransportStatus.carriedOut) {
                  return Wrap(
                    children:
                        //Text(transport.id),
                        transport.pictures
                            .map(
                              (url) => Container(
                                height: 100,
                                width: 100,
                                child: Text(''),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(url),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  );
                } else {
                  return Container(height: 1);
                }
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
