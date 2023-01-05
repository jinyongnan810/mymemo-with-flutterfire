import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mymemo_with_flutterfire/providers/auth_notifier_provider.dart';
import 'package:mymemo_with_flutterfire/providers/my_user_info_provider.dart';

class MyUserProfile extends ConsumerWidget {
  const MyUserProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notLoggedInProfile = Tooltip(
      message: K.of(context)!.loginHint,
      child: IconButton(
        onPressed: () async {
          ref.read(authNotifierProvider.notifier).signIn();
        },
        icon: const Icon(Icons.person),
      ),
    );

    final myUserInfoFuture = ref.watch(myUserInfoProvider);

    return myUserInfoFuture.when(
      data: (myUserInfo) {
        if (myUserInfo == null) {
          return notLoggedInProfile;
        }

        return Tooltip(
          message: K.of(context)!.loggedInHint(myUserInfo.email),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: PopupMenuButton(
              tooltip: K.of(context)!.loggedInHint(myUserInfo.email),
              position: PopupMenuPosition.under,
              onSelected: (value) async {
                if (value == 'signOut') {
                  await ref.read(authNotifierProvider.notifier).logout();
                }
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 'signOut',
                  child: Text(K.of(context)!.logoutHint),
                ),
              ],
              child: CircleAvatar(
                radius: 20,
                // in AppBar, regular background image won't fit
                // this way worked
                child: ClipOval(
                  child: Image.network(
                    myUserInfo.photoUrl,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      error: (_, __) {
        return notLoggedInProfile;
      },
      loading: () => const CircularProgressIndicator(),
    );
  }
}
