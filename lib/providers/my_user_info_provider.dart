import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/models/profile.dart';
import 'package:mymemo_with_flutterfire/providers/user_id_provider.dart';
import 'package:mymemo_with_flutterfire/providers/user_info_provider.dart';

final myUserInfoProvider =
    FutureProvider.autoDispose<UserProfile?>((ref) async {
  final myUserId = ref.watch(userIdProvider);
  if (myUserId == null) {
    return null;
  }
  final myUserInfo = ref.watch(userInfoProvider(myUserId).future);
  final myUser = await myUserInfo;

  return myUser;
});
