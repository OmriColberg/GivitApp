import 'package:flutter/material.dart';
import 'package:givit_app/core/shared/givit_logo.dart';
import 'package:givit_app/main_page_feature/presentation/pages/main_page.dart';
import 'package:givit_app/profile_page_feature/presentation/pages/profile_page.dart';
import 'package:givit_app/services/auth.dart';
import 'package:givit_app/transport_log_feature/transport_log_page.dart';

class MainMenuUser extends StatelessWidget {
  const MainMenuUser({
    required this.size,
    required AuthService auth,
  }) : _auth = auth;

  final Size size;
  final AuthService _auth;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: 4,
        length: 5,
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
                    icon: Icon(Icons.fiber_new),
                    text: '  מוצר\nלאיסוף',
                  ),
                  Tab(
                    icon: Icon(Icons.family_restroom),
                    text: 'קהילת\n givit',
                  ),
                  Tab(
                    icon: Icon(Icons.airport_shuttle),
                    text: '  מעקב\nהובלות ',
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
                TransportLogPage(),
                TransportLogPage(),
                TransportLogPage(),
                ProfilePage(size: size),
                MainPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
