import 'package:flutter/material.dart';
//import 'package:givit_app/core/di/di.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/main_menu_feature/presentation/pages/main_menu_admin.dart';
import 'package:givit_app/main_menu_feature/presentation/pages/main_menu_user.dart';
import 'package:givit_app/services/auth.dart';
import 'package:givit_app/services/database.dart';
import 'package:provider/provider.dart';

class MainMenu extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    GivitUser user = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: user.uid);
    return StreamBuilder<GivitUser>(
      stream: db.givitUserData,
      builder: (context, snapshotGivitUser) {
        if (!snapshotGivitUser.hasData) {
          return Loading();
        }
        GivitUser? givitUser = snapshotGivitUser.data;
        final bool isAdmin = givitUser!.role == 'Admin';

        return isAdmin
            ? MainMenuAdmin(size: size, auth: _auth)
            : MainMenuUser(size: size, auth: _auth);
      },
    );
  }
}
