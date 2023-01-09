import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/providers/logged_in_status_provider.dart';
import 'package:mymemo_with_flutterfire/typedef.dart';

final userIdProvider = Provider<UserId?>(
  (ref) {
    final _ = ref.watch(loggedInStatusProvider);

    return FirebaseAuth.instance.currentUser?.uid;
  },
);
