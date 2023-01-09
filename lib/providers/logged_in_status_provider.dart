import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/shared/show_snackbar.dart';
import 'package:mymemo_with_flutterfire/typedef.dart';
import 'package:mymemo_with_flutterfire/utils/firestore_util.dart';

final loggedInStatusProvider = StreamProvider<IsLoggedIn>((ref) {
  final controller = StreamController<IsLoggedIn>();
  controller.sink.add(false);
  final subscription =
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (user == null) {
      controller.sink.add(false);
      debugPrint('User is currently signed out!');
    } else {
      controller.sink.add(true);
      try {
        await FirestoreUtil.updateUser(user);
      } catch (e) {
        showSnackBar('Error updating user $e');
      }
      debugPrint('User is signed in!');
    }
  });
  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });

  return controller.stream;
});
