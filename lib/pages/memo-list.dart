import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mymemo_with_flutterfire/components/memo-list.dart';
import 'package:mymemo_with_flutterfire/providers/auth.dart';
import 'package:mymemo_with_flutterfire/shared/memo-list-search-delegate.dart';
import 'package:provider/provider.dart';

class MemoListPage extends StatelessWidget {
  static String routeName = '/';
  const MemoListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple, Colors.orange])),
      child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Kin's Page"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(
                        context: context, delegate: MemoListSearchDelegate());
                  },
                  icon: const Icon(Icons.search))
            ],
            leading:
                // currently only supports web
                kIsWeb
                    ? Consumer<Auth>(
                        builder: (ctx, auth, _) => auth.signedIn
                            ? Tooltip(
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: PopupMenuButton(
                                      tooltip: auth.myProfile.email,
                                      position: PopupMenuPosition.under,
                                      onSelected: (value) async {
                                        if (value == 'signOut') {
                                          await auth.signOut();
                                        }
                                      },
                                      itemBuilder: (ctx) => [
                                        const PopupMenuItem(
                                          child: Text('Sign out'),
                                          value: 'signOut',
                                        ),
                                      ],
                                      child: CircleAvatar(
                                        radius: 20,
                                        // in Appbar, ragular background image won't fit
                                        // this way worked
                                        child: ClipOval(
                                            child: Image.network(
                                          auth.myProfile.photoUrl,
                                        )),
                                      ),
                                    )),
                                message:
                                    'Signed in with ${auth.myProfile.email}. Click to sign out.',
                              )
                            : Tooltip(
                                child: IconButton(
                                    onPressed: () async {
                                      await auth.signIn();
                                    },
                                    icon: const Icon(Icons.person)),
                                message: 'Sign in',
                              ))
                    : Container(),
          ),
          body: const MemoList(),
          floatingActionButton: kIsWeb
              ? Consumer<Auth>(
                  builder: (ctx, auth, _) => auth.signedIn
                      ? Container(
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.purple, Colors.orange]),
                              borderRadius: BorderRadius.circular(30)),
                          child: FloatingActionButton(
                            child: const Icon(Icons.add),
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            onPressed: () {
                              GoRouter.of(context).go('/memos/new');
                            },
                          ),
                        )
                      : Container())
              : Container()),
    );
  }
}
