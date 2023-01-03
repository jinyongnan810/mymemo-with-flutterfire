import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/models/auth/auth_result.dart';
import 'package:mymemo_with_flutterfire/models/auth/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  String? get userId => FirebaseAuth.instance.currentUser?.uid;
  bool get isLoggedIn => userId != null;
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';
  String? get email => FirebaseAuth.instance.currentUser?.email;
  AuthNotifier() : super(const AuthState.unknown()) {
    if (isLoggedIn) {
      state = AuthState(
        result: AuthResult.success,
        isLoading: false,
        userId: userId,
      );
    }
  }
}
