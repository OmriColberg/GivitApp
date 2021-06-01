import 'package:flutter/material.dart';
import 'package:givit_app/admin_feature/presentation/pages/add_product_page.dart';

class AdminPage extends StatefulWidget {
  AdminPage({Key key}) : super(key: key);

  @override
  _AaminPageState createState() => _AaminPageState();
}

class _AaminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100],
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              )
            },
            child: Text('הוספת מוצר חדש לחיפוש'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('הוספת הובלה חדשה'),
          ),
        ],
      ),
    );
  }
}
