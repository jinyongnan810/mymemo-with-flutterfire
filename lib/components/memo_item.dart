// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';
import 'package:mymemo_with_flutterfire/providers/memos_notifier_provider.dart';
import 'package:mymemo_with_flutterfire/providers/user_id_provider.dart';
import 'package:mymemo_with_flutterfire/providers/user_info_provider.dart';

class MemoItem extends ConsumerWidget {
  final Memo memo;
  const MemoItem(this.memo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updatedAt = DateTime.fromMillisecondsSinceEpoch(memo.updatedAt!);
    final fullDate = DateFormat('yyyy/MM/dd H:m').format(updatedAt);
    final shortDate = DateFormat('MM/dd H:m').format(updatedAt);
    final date = (updatedAt.year == DateTime.now().year) ? shortDate : fullDate;

    final user = ref.read(userInfoProvider(memo.userId));
    final myUserId = ref.watch(userIdProvider);

    final avatar = user.when(
      data: (userInfo) => userInfo == null
          ? const SizedBox.shrink()
          : Tooltip(
              message: userInfo.email,
              child: Row(
                children: [
                  userInfo.photoUrl == ''
                      ? const CircleAvatar(
                          radius: 15,
                          child: Icon(Icons.person),
                        )
                      : CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(userInfo.photoUrl),
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(userInfo.displayName),
                ],
              ),
            ),
      error: (_, __) => const SizedBox.shrink(),
      loading: () => const CircularProgressIndicator(),
    );

    return InkWell(
      highlightColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(10),
      onTap: () => context.go('/memos/${memo.id}'),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Text(
                memo.title,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.only(bottom: 10, left: 10),
            child: Tooltip(
              message: 'Updated at $fullDate',
              child: Text(
                date,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, top: 10),
            alignment: Alignment.topLeft,
            child: avatar,
          ),
          memo.userId == myUserId
              ? Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () async {
                      final bool? confirmed = await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(
                            'Are you sure to delete ${memo.title}',
                          ),
                          content: const Text(
                            'This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await memo.delete();
                        ref
                            .read(memosNotifierProvider.notifier)
                            .deleteItem(memo);
                      }
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
