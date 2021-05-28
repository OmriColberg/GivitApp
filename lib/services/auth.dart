import 'package:firebase_auth/firebase_auth.dart';
import 'package:givit_app/core/models/givit_user.dart';
import 'package:givit_app/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GivitUser _givitUserFromFireBaseUser(User user) {
    return user != null ? GivitUser(uid: user.uid, email: user.email) : null;
  }

  Stream<GivitUser> get user {
    return _auth.authStateChanges().map(_givitUserFromFireBaseUser);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String email, String fullName, String password, int phoneNumber) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid)
          .updateGivitUserData(email, fullName, password, phoneNumber);
      return _givitUserFromFireBaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
