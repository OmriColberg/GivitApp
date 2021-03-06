import 'package:flutter/material.dart';
//import 'package:givit_app/core/di/di.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/login_feature/core/authenticate.dart';
import 'package:givit_app/main_menu_feature/presentation/pages/main_menu.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GivitUser user = Provider.of<GivitUser>(context);
    //final GivitUser user = getIt();

    return user.uid == '' ? Authenticate() : MainMenu();
  }
}
