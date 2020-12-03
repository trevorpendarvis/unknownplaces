import 'package:UnknownPlaces/model/unknownplaces.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseController {
  static Future signIn(String email, String password) async {
    print(email);
    print(password);

    AuthResult auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return auth.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> updateUserInfo(String username, FirebaseUser user) async {
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = username;
    await user.updateProfile(updateInfo);
  }

  static Future<void> signUp(String email, String password) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> addFav(UnknownPlaces places) async {
    places.timestamp = DateTime.now();
    Firestore.instance
        .collection(UnknownPlaces.COLLECTION)
        .add(places.serialize());
  }
}
