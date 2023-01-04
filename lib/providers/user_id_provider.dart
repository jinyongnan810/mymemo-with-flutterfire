import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/typedef.dart';

final userIdProvider = Provider<UserId?>(
  (ref) {
    return FirebaseAuth.instance.currentUser?.uid;
  },
);
