import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mymemo_with_flutterfire/components/memo-list.dart';
import 'package:mymemo_with_flutterfire/providers/auth.dart';
import 'package:provider/provider.dart';

class MemoListPage extends StatelessWidget {
  static String routeName = '/';
  const MemoListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Kin's Page"),
          actions: [
            // currently only supports web
            kIsWeb
                ? Consumer<Auth>(
                    builder: (ctx, auth, _) => auth.signedIn
                        ? TextButton(
                            onPressed: () async {
                              await auth.signOut();
                            },
                            child: const Text(
                              'Sign out',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ))
                        : TextButton(
                            onPressed: () async {
                              await auth.signIn();
                            },
                            child: const Text(
                              'Sign in',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )))
                : Container()
          ],
        ),
        body: const MemoList(),
        floatingActionButton: kIsWeb
            ? Consumer<Auth>(
                builder: (ctx, auth, _) => auth.signedIn
                    ? FloatingActionButton(
                        child: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/detail');
                        },
                      )
                    : Container())
            : Container());
  }
}
