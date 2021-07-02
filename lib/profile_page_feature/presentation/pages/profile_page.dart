import 'package:flutter/material.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/profile_page_feature/presentation/pages/edit_profile_page.dart';
import 'package:givit_app/services/database.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final Size size;

  const ProfilePage({Key key, @required this.size}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    GivitUser user = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: user.uid);
    return StreamBuilder<GivitUser>(
        stream: db.userData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          GivitUser givitUser = snapshot.data;
          print("PRODUCTS: ${givitUser.products}");
          return Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hello ${givitUser.fullName}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditProfilePage(size: widget.size)),
                        )
                      },
                      child: Text('Edit Personal Info'),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
