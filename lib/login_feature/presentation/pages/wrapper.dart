import 'package:flutter/material.dart';
import 'package:givit_app/login_feature/core/authenticate.dart';
import 'package:givit_app/models/givit_user.dart';
import 'package:provider/provider.dart';
import 'package:givit_app/main_menu.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('wrapper');
    final user = Provider.of<GivitUser>(context);
    print(user);

    return user == null ? Authenticate() : MainMenu();
  }
}
