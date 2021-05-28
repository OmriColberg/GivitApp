import 'package:flutter/material.dart';
import 'package:givit_app/core/di/di.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/main_menu_feature/presentation/pages/main_menu_admin.dart';
import 'package:givit_app/main_menu_feature/presentation/pages/main_menu_user.dart';
import 'package:givit_app/services/auth.dart';
import 'package:givit_app/services/database.dart';
import 'package:provider/provider.dart';

class MainMenu extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final GivitUser givitUser = Provider.of<GivitUser>(context);
    //                        = getIt();
    final bool isAdmin = givitUser.role == 'Admin';
    Size size = MediaQuery.of(context).size;
    return /*Container(child: FutureBuilder<String>(
      future: DatabaseService(),
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          children = <Widget>[
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Result: ${snapshot.data}'),
            )
          ];
        } else if (snapshot.hasError) {
          children = <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ];
        } else {
          children = const <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            )
          ];
        }
      },
    ));*/

        isAdmin
            ? MainMenuAdmin(size: size, auth: _auth)
            : MainMenuAdmin(size: size, auth: _auth);
    //MainMenuUser(size: size, auth: _auth);
  }
}
