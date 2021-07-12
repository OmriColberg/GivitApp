import 'package:flutter/material.dart';
import 'package:givit_app/core/shared/givit_logo.dart';
import 'package:givit_app/givit_community_feature/givit_community_page.dart';
import 'package:givit_app/main_page_feature/presentation/pages/main_page.dart';
import 'package:givit_app/profile_page_feature/presentation/pages/profile_page.dart';
import 'package:givit_app/services/auth.dart';

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
        initialIndex: 2,
        length: 3,
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
                    await _auth
                        .signOut()
                        .then((_) => print('successful signout'))
                        .catchError((onError) => print(onError));
                  },
                ),
              ],
              bottom: TabBar(
                tabs: [
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
                GivitCommunityPage(),
                ProfilePage(size: size),
                MainPage(size: size),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
