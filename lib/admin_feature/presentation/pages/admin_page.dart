import 'package:flutter/material.dart';
import 'package:givit_app/admin_feature/presentation/pages/add_product_page.dart';

class AdminPage extends StatefulWidget {
  AdminPage({required this.size});
  final Size size;
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
                MaterialPageRoute(
                  builder: (context) => AddProductPage(size: widget.size),
                ),
              ),
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
