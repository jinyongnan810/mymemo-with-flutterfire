import 'package:flutter/material.dart';
import 'package:mymemo_with_flutterfire/components/memo-item.dart';
import 'package:mymemo_with_flutterfire/providers/memos.dart';
import 'package:provider/provider.dart';

class MemoList extends StatefulWidget {
  const MemoList({Key? key}) : super(key: key);

  @override
  State<MemoList> createState() => _MemoListState();
}

class _MemoListState extends State<MemoList> {
  late final Future<void>? _fetchFirstItems;
  late final ScrollController _scrollController;
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchFirstItems =
        Provider.of<Memos>(context, listen: false).fetchFirstItems();
    _scrollController = ScrollController();
    _scrollController.addListener(() async {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _loadingMore = true;
        });
        // await Future.delayed(const Duration(seconds: 5));
        await Provider.of<Memos>(context, listen: false).fetchNextItems();
        setState(() {
          _loadingMore = false;
        });
        return;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchFirstItems,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              print(dataSnapshot.error);
              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              //   content: Text('Error loading the memos.Please refresh again.'),
              //   duration: Duration(seconds: 5),
              // ));
            }

            return Consumer<Memos>(
                builder: (ctx, memos, _) => Column(
                      children: [
                        Expanded(
                            child: GridView.count(
                          crossAxisCount: 4,
                          controller: _scrollController,
                          children: [
                            ...memos.items.map((memo) => MemoItem(memo))
                          ],
                        )),
                        if (_loadingMore)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                      ],
                    ));
          }
        });
  }
}
