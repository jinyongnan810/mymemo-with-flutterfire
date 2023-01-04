import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/shared/show_snackbar.dart';
import 'package:mymemo_with_flutterfire/typedef.dart';
import 'package:mymemo_with_flutterfire/utils/firestore_util.dart';

class AuthNotifier extends StateNotifier<IsLoading> {
  String? get userId => FirebaseAuth.instance.currentUser?.uid;
  bool get isLoggedIn => userId != null;
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';
  String? get email => FirebaseAuth.instance.currentUser?.email;

  set isLoading(IsLoading loading) => state = loading;

  AuthNotifier() : super(false);

  Future<void> signIn() async {
    isLoading = true;
    // https://firebase.flutter.dev/docs/auth/social/
    // not working with desktop
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    // googleProvider
    //     .addScope('https://www.googleapis.com/auth/contacts.readonly');
    final userCredential =
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
    final user = userCredential.user;
    if (user == null) {
      isLoading = false;

      return;
    }
    try {
      await FirestoreUtil.updateUser(user);
      showSnackBar('Signed in with ${user.email ?? user.displayName}');
    } catch (e) {
      showSnackBar('Error updating user $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> logout() async {
    isLoading = true;
    await FirebaseAuth.instance.signOut();
    isLoading = false;
    showSnackBar('Signed out.');
  }
}
