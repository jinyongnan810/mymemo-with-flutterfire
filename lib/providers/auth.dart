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
    await FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void watch() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        signedIn = false;
        userId = '';
        notifyListeners();
        print('User is currently signed out!');
      } else {
        userId = user.uid;
        signedIn = true;
        notifyListeners();
        print('User is signed in!');
      }
    });
  }
}
