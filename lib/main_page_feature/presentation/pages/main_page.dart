import 'package:flutter/material.dart';
import 'package:givit_app/main_page_feature/presentation/pages/assign_card.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MainPage();
  }
}

class _MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100],
      height: 400.0,
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: DeliveryAssign(
                title: 'דרושים מובילים',
                body: 'כאן יהיה פירוט יתר',
                schedule: 'לשיבוץ הובלה',
                key: key,
              ),
            ),
            Container(
              child: DeliveryAssign(
                title: 'דרושים מחפשים',
                schedule: 'לשיבוץ לחיפוש',
                key: key,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
