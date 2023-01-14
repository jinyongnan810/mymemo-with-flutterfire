import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/components/memo_item.dart';
import 'package:mymemo_with_flutterfire/providers/memos_notifier_provider.dart';

class MemoList extends StatefulHookConsumerWidget {
  const MemoList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MemoListState();
}

class _MemoListState extends ConsumerState<MemoList> {
  late final ScrollController _scrollController;
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() async {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        if (_loadingMore) return;
        setState(() {
          _loadingMore = true;
        });
        await ref.read(memosNotifierProvider.notifier).fetchNextItems();
        setState(() {
          _loadingMore = false;
        });
      }
    });
    () async {
      // this line prevents error
      await Future.delayed(const Duration(seconds: 0));
      await ref.read(memosNotifierProvider.notifier).fetchFirstItems();
    }();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memosState = ref.watch(memosNotifierProvider);

    return Column(
      children: [
        Expanded(child: LayoutBuilder(
          builder: ((context, constraints) {
            int cols = constraints.maxWidth > 1200
                ? 4
                : constraints.maxWidth > 600
                    ? 3
                    : 2;

            return GridView.count(
              crossAxisCount: cols,
              controller: _scrollController,
              children: [
                ...memosState.memos.map((memo) => MemoItem(memo)),
              ],
            );
          }),
        )),
        if (_loadingMore)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
