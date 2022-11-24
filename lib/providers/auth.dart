import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mymemo_with_flutterfire/models/profile.dart';
import 'package:mymemo_with_flutterfire/shared/show_snackbar.dart';

class Auth extends ChangeNotifier {
  bool signedIn = false;
  String userId = '';
  UserProfile myProfile = UserProfile('', '', '', '');
  Map<String, UserProfile> cachedProfile = {};
  Future<void> signIn() async {
    // https://firebase.flutter.dev/docs/auth/social/
    // not working with desktop
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    // googleProvider
    //     .addScope('https://www.googleapis.com/auth/contacts.readonly');
    final userCredential =
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
    final user = userCredential.user;
    if (user == null) return;
    await updateUser(user);
    showSnackBar('Signed in with ${user.email ?? user.displayName}');
  }

  Future<void> updateUser(User user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'displayName': user.displayName ?? '',
      'photoUrl': user.photoURL ?? '',
      'email': user.email ?? '',
    });
    cachedProfile[user.uid] = UserProfile(
      user.uid,
      user.displayName ?? '',
      user.photoURL ?? '',
      user.email ?? '',
    );
  }

  Future<UserProfile> getUser(String id) async {
    if (cachedProfile.containsKey(id)) {
      return cachedProfile[id]!;
    }
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    if (snapshot.exists) {
      final user = UserProfile.fromJson(id, snapshot.data()!);
      cachedProfile[id] = user;

      return user;
    } else {
      final user = UserProfile(id, 'User Not Found', '', '');
      cachedProfile[id] = user;

      return user;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    showSnackBar('Signed out.');
  }

  void watch() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        signedIn = false;
        userId = '';
        myProfile = UserProfile('', '', '', '');
        notifyListeners();
        debugPrint('User is currently signed out!');
      } else {
        userId = user.uid;
        myProfile = UserProfile(
          user.uid,
          user.displayName ?? '',
          user.photoURL ?? '',
          user.email ?? '',
        );
        await updateUser(user);
        signedIn = true;
        notifyListeners();
        debugPrint('User is signed in!');
      }
    });
  }
}
