import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/components/add_new_memo_button.dart';
import 'package:mymemo_with_flutterfire/components/memo_list.dart';
import 'package:mymemo_with_flutterfire/components/my_user_profile.dart';
import 'package:mymemo_with_flutterfire/shared/memo_list_search_delegate.dart';

class MemoListPage extends ConsumerWidget {
  static String routeName = '/';
  const MemoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple, Colors.orange],
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(K.of(context)!.appTitle),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MemoListSearchDelegate(),
                );
              },
              icon: const Icon(Icons.search),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: MyUserProfile(),
            ),
          ],
        ),
        body: const MemoList(),
        floatingActionButton: const AddNewMemoButton(),
      ),
    );
  }
}
