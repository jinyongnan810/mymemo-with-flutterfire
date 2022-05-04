import 'package:flutter/material.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';
import 'package:mymemo_with_flutterfire/models/profile.dart';
import 'package:mymemo_with_flutterfire/pages/memo-detail.dart';
import 'package:mymemo_with_flutterfire/providers/auth.dart';
import 'package:mymemo_with_flutterfire/providers/memos.dart';
import 'package:provider/provider.dart';

class MemoItem extends StatelessWidget {
  final Memo memo;
  const MemoItem(this.memo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return InkWell(
      highlightColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(10),
      onTap: () => Navigator.of(context)
          .pushNamed(MemoDetailPage.routeName, arguments: memo.id),
      child: Stack(
        children: [
          Center(
            child: Text(memo.title),
          ),
          Container(
              padding: const EdgeInsets.only(left: 10, top: 10),
              alignment: Alignment.topLeft,
              child: FutureBuilder<UserProfile>(
                future: auth.getUser(memo.userId),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final photo = snapshot.data!.photoUrl;
                    return Row(
                      children: [
                        photo == ''
                            ? const CircleAvatar(
                                radius: 15, child: const Icon(Icons.person))
                            : CircleAvatar(
                                radius: 15,
                                backgroundImage:
                                    NetworkImage(snapshot.data!.photoUrl),
                              ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(snapshot.data!.displayName)
                      ],
                    );
                  }
                  return const CircularProgressIndicator();
                },
              )),
          Consumer<Auth>(builder: ((context, auth, child) {
            return auth.signedIn && memo.userId == auth.userId
                ? Container(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () async {
                          final confirmed = await showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text(
                                        'Are you sure to delete ${memo.title}'),
                                    content: const Text(
                                        'This action cannot be undone.'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: const Text('Cancel')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          child: const Text('Delete')),
                                    ],
                                  ));
                          if (confirmed == true) {
                            await memo.delete();
                            Provider.of<Memos>(context, listen: false)
                                .deleteItem(memo);
                          }
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.grey,
                        )),
                  )
                : Container();
          }))
        ],
      ),
    );
  }
}
