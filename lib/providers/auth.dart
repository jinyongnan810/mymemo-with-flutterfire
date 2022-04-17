import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends ChangeNotifier {
  bool signedIn = false;
  String userId = '';
  Future<void> signIn() async {
    // https://firebase.flutter.dev/docs/auth/social/
    // not working with desktop
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    // googleProvider
    //     .addScope('https://www.googleapis.com/auth/contacts.readonly');
    final googleUserCredential =
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
    userId = googleUserCredential.user?.uid ?? '';
    if (userId != '') signedIn = true;
    print('userId:$userId, signedIn:$signedIn');
    notifyListeners();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    signedIn = false;
    userId = '';
    notifyListeners();
  }
}
