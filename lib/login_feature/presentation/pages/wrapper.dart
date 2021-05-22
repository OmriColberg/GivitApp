import 'package:flutter/material.dart';
import 'package:givit_app/core/di/di.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/login_feature/core/authenticate.dart';
import 'package:givit_app/main_menu_feature/presentation/pages/main_menu.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GivitUser user = getIt();

    return user == null ? Authenticate() : MainMenu();
  }
}
