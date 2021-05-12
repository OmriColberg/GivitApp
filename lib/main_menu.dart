import 'package:flutter/material.dart';
import 'package:givit_app/main_page_feature/presentation/pages/main_page.dart';
import 'package:givit_app/profile_page_featre/profile_page.dart';
import 'package:givit_app/services/auth.dart';

class MainMenu extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size;
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: 4,
        length: 5,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Center(
                child: Container(
                  width: 200, //size.width * 0.1,
                  height: 150, //size.height * 0.1,
                  child: Image.asset('lib/core/assets/givit-white.png'),
                ),
              ),
              actions: [
                TextButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('logout'),
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
              // title: Text('Tabs Demo'),
            ),
            body: TabBarView(
              children: [
                ProfilePage(),
                ProfilePage(),
                ProfilePage(),
                ProfilePage(),
                MainPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
