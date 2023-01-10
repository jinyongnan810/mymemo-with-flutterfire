import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/models/profile.dart';
import 'package:mymemo_with_flutterfire/typedef.dart';

// FIXME: cannot fetch user when logout
final userInfoProvider = FutureProvider.family
    .autoDispose<UserProfile?, UserId>((ref, userId) async {
  final snapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (snapshot.exists) {
    final user = UserProfile.fromJson(userId, snapshot.data()!);

    return user;
  }

  return null;
});
