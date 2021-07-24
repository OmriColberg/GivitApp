import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/services/database.dart';
import 'package:provider/provider.dart';

/// This is the stateless widget that the main application instantiates.
class GivitCommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GivitUser user = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: user.uid);
    return StreamBuilder<QuerySnapshot>(
      stream: db.transportsData,
      builder: (context, snapshotTransport) {
        if (snapshotTransport.hasError) {
          return Text('אירעה תקלה, נא לפנות למנהלים');
        }

        if (snapshotTransport.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        return Container(
          child: Center(
            child: Text(
              'Community',
              style: TextStyle(fontSize: 40),
            ),
          ),
        );
      },
    );
  }
}
