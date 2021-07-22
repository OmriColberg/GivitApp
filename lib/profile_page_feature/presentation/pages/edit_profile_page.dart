import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/core/shared/loading.dart';
import 'package:givit_app/profile_page_feature/presentation/pages/param_info_profile_page.dart';
import 'package:givit_app/profile_page_feature/presentation/pages/sub_title_profile_page.dart';
import 'package:givit_app/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class EditProfilePage extends StatefulWidget {
  final Size size;
  final GivitUser? givitUser;

  EditProfilePage(this.size, this.givitUser);

  @override
  MapScreenState createState() =>
      MapScreenState(size: size, givitUser: givitUser);
}

class MapScreenState extends State<EditProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final Size size;
  final GivitUser? givitUser;
  bool imagePicked = false;
  String? imagePath = '';

  MapScreenState({required this.size, required this.givitUser});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GivitUser user = Provider.of<GivitUser>(context);
    final DatabaseService db = DatabaseService(uid: user.uid);
    final ImagePicker _picker = ImagePicker();

    return StreamBuilder<GivitUser>(
        stream: db.userData,
        builder: (context, snapshotUser) {
          if (snapshotUser.hasError) {
            print(snapshotUser.error);
            return Text('אירעה תקלה, נא לפנות למנהלים');
          }

          if (snapshotUser.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          GivitUser? givitUser = snapshotUser.data;

          return SafeArea(
            child: Scaffold(
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
                                  child: Stack(fit: StackFit.loose, children: <
                                      Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        givitUser!.profilePictureURL == ''
                                            ? Container(
                                                width: 140.0,
                                                height: 140.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: ExactAssetImage(
                                                        'lib/core/assets/default_profile_pic.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : ClipOval(
                                                child: Image.network(
                                                  givitUser.profilePictureURL,
                                                  fit: BoxFit.fill,
                                                  height: 140,
                                                  width: 140,
                                                ),
                                              )
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
                                              onTap: () async {
                                                final XFile? image =
                                                    await _picker.pickImage(
                                                        source: ImageSource
                                                            .gallery);
                                                Reference reference = db.storage
                                                    .ref()
                                                    .child(
                                                        'Profile pictures/${givitUser.uid}');
                                                UploadTask uploadTask =
                                                    reference.putFile(
                                                        File(image!.path));
                                                await uploadTask.whenComplete(
                                                    () => reference
                                                        .getDownloadURL()
                                                        .then((fileURL) => {
                                                              db.updateGivitUserFields({
                                                                'Profile Picture URL':
                                                                    fileURL
                                                              })
                                                            }));
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
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              _status
                                                  ? _getEditIcon()
                                                  : Container(),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'פרטיים אישיים',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                  SubTitlePersonalArea(title: 'שם פרטי ומשפחה'),
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ParamInfoPersonalArea(
                                        controller: fullNameController,
                                        paramInfo: givitUser.fullName,
                                        obscure: false,
                                        status: _status),
                                  ),
                                  SubTitlePersonalArea(title: 'אי-מייל'),
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ParamInfoPersonalArea(
                                      controller: emailController,
                                      paramInfo: givitUser.email,
                                      obscure: false,
                                      status: _status,
                                    ),
                                  ),
                                  SubTitlePersonalArea(title: 'מספר טלפון'),
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ParamInfoPersonalArea(
                                      controller: phoneNumberController,
                                      paramInfo:
                                          givitUser.phoneNumber.toString(),
                                      obscure: false,
                                      status: _status,
                                    ),
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
                )),
          );
        });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  Widget _getActionButtons(DatabaseService db, GivitUser? givitUser) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _saveCancelButton('שמור', () async {
            await db.updateGivitUserFields({
              'Email': emailController.text == ''
                  ? givitUser!.email
                  : emailController.text,
              'Full Name': fullNameController.text == ''
                  ? givitUser!.fullName
                  : fullNameController.text,
              'Phone Number': phoneNumberController.text == ''
                  ? givitUser!.phoneNumber
                  : int.parse(phoneNumberController.text),
            });
            setState(() {
              _status = true;
              FocusScope.of(context).requestFocus(FocusNode());
            });
          }),
          _saveCancelButton('בטל', () {
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
