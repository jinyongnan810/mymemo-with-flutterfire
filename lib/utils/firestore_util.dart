import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreUtil {
  static Future<void> updateUser(User user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'displayName': user.displayName ?? '',
      'photoUrl': user.photoURL ?? '',
      'email': user.email ?? '',
    });
  }
}
