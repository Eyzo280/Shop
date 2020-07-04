import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopapp/models/user.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null
        ? User(uid: user.uid, displayName: user.displayName)
        : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future signUpWithEmailAndPassword({
    @required email,
    @required password,
    @required displayName,
  }) async {
    try {
      AuthResult _result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = _result.user;
      UserUpdateInfo updateInfo = new UserUpdateInfo();
      updateInfo.displayName = displayName;
      await user.updateProfile(updateInfo);
      return user;
    } catch (err) {
      throw err;
    }
  }

  Future signInWithEmailAndPassword(
      {@required email, @required password}) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (err) {
      throw err;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (err) {
      print(err);
    }
  }
}
