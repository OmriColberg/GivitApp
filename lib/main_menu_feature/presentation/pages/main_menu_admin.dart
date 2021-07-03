import 'package:flutter/material.dart';
import 'package:givit_app/admin_feature/presentation/pages/admin_page.dart';
import 'package:givit_app/core/shared/givit_logo.dart';
import 'package:givit_app/main_page_feature/presentation/pages/main_page.dart';
import 'package:givit_app/profile_page_feature/presentation/pages/edit_profile_page.dart';
import 'package:givit_app/profile_page_feature/presentation/pages/profile_page.dart';
import 'package:givit_app/services/auth.dart';
import 'package:givit_app/transport_log_feature/transport_log_page.dart';

class MainMenuAdmin extends StatelessWidget {
  const MainMenuAdmin({
    required this.size,
    required AuthService auth,
  }) : _auth = auth;

  final Size size;
  final AuthService _auth;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: 3,
        length: 4,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Center(
                child: GivitLogo(
                  size: size,
                ),
              ),
              actions: [
                TextButton.icon(
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  label: Text(
                    'logout',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    await _auth.signOut();
                  },
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.assignment_ind),
                    text: 'מנהלים',
                  ),
                  Tab(
                    icon: Icon(Icons.family_restroom),
                    text: 'קהילת\n givit',
                  ),
                  Tab(
                    icon: Icon(Icons.person),
                    text: 'אזור\nאישי',
                  ),
                  Tab(
                    icon: Icon(Icons.home_outlined),
                    text: 'עמוד\nראשי',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                AdminPage(size: size),
                TransportLogPage(),
                EditProfilePage(size: size),
                MainPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
