import 'package:flutter/material.dart';
import 'package:givit_app/login_feature/presentation/pages/wrapper.dart';
import 'package:givit_app/models/givit_user.dart';
import 'package:givit_app/services/auth.dart';
import 'package:provider/provider.dart';

class GivitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<GivitUser>.value(
      value: AuthService().user,
      initialData: GivitUser(),
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
