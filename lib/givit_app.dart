import 'package:flutter/material.dart';
import 'package:givit_app/login_feature/presentation/pages/wrapper.dart';
import 'package:givit_app/login_feature/presentation/state_management/login_provider.dart';
import 'package:givit_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'core/models/givit_user.dart';

class GivitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
      ],
      child: StreamProvider<GivitUser>.value(
        value: AuthService().user,
        initialData: GivitUser(),
        child: MaterialApp(
          home: Wrapper(),
        ),
      ),
    );
  }
}
