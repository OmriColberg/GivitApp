import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/profile_page_feature/presentation/pages/param_info_profile_page.dart';
import 'package:givit_app/profile_page_feature/presentation/pages/sub_title_profile_page.dart';
import 'package:givit_app/services/database.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final Size size;

  EditProfilePage({required this.size});

  @override
  MapScreenState createState() => MapScreenState(size: size);
}

class MapScreenState extends State<EditProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final Size size;

  MapScreenState({required this.size});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GivitUser user = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: user.uid);
    return StreamBuilder<GivitUser>(
        stream: db.userData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          GivitUser? givitUser = snapshot.data;
          return Scaffold(
              backgroundColor: Colors.blue[100],
              appBar: AppBar(
                backgroundColor: Colors.blue[400],
                elevation: 0.0,
                title: Text('אזור אישי'),
              ),
              body: Container(
                color: Colors.white,
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: size.height * 0.28,
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Stack(
                                    fit: StackFit.loose,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              width: 140.0,
                                              height: 140.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: ExactAssetImage(
                                                      'lib/core/assets/default_profile_pic.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 90.0, right: 100.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              GestureDetector(
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  radius: 25.0,
                                                  child: Icon(
                                                    Icons.camera_alt,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onTap: () {
                                                  // TODO: implemenet selection of profile picture
                                                },
                                              )
                                            ],
                                          )),
                                    ]),
                              )
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              'Personal Information',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            _status
                                                ? _getEditIcon()
                                                : Container(),
                                          ],
                                        )
                                      ],
                                    )),
                                SubTitlePersonalArea(title: 'Name'),
                                ParamInfoPersonalArea(
                                    controller: fullNameController,
                                    paramInfo: givitUser!.fullName,
                                    obscure: false,
                                    status: _status),
                                SubTitlePersonalArea(title: 'Email'),
                                ParamInfoPersonalArea(
                                  controller: emailController,
                                  paramInfo: givitUser.email,
                                  obscure: false,
                                  status: _status,
                                ),
                                SubTitlePersonalArea(title: 'Password'),
                                ParamInfoPersonalArea(
                                  controller: passwordController,
                                  paramInfo: givitUser.password,
                                  obscure: true,
                                  status: _status,
                                ),
                                SubTitlePersonalArea(title: 'Phone Number'),
                                ParamInfoPersonalArea(
                                  controller: phoneNumberController,
                                  paramInfo: givitUser.phoneNumber.toString(),
                                  obscure: false,
                                  status: _status,
                                ),
                                !_status
                                    ? _getActionButtons(db, givitUser)
                                    : Container(),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  Widget _getActionButtons(DatabaseService db, GivitUser givitUser) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _saveCancelButton('Save', () async {
            await db.updateGivitUserFields({
              'Email': emailController.text == ''
                  ? givitUser.email
                  : emailController.text,
              'Full Name': fullNameController.text == ''
                  ? givitUser.fullName
                  : fullNameController.text,
              'Password': passwordController.text == ''
                  ? givitUser.password
                  : passwordController.text,
              'Phone Number': phoneNumberController.text == ''
                  ? givitUser.phoneNumber
                  : int.parse(phoneNumberController.text),
            });
            setState(() {
              _status = true;
              FocusScope.of(context).requestFocus(FocusNode());
            });
          }),
          _saveCancelButton('Cancel', () {
            setState(() {
              _status = true;
              FocusScope.of(context).requestFocus(FocusNode());
            });
          }),
        ],
      ),
    );
  }

  Expanded _saveCancelButton(String text, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Container(
            child: ElevatedButton(
          child: Text(text),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              )),
          onPressed: onPressed,
        )),
      ),
      flex: 2,
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
