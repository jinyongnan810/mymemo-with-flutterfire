import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchFirstItems =
        Provider.of<Memos>(context, listen: false).fetchFirstItems();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<Memos>(context, listen: false).fetchNextItems();
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
              builder: (ctx, memos, _) => ListView.builder(
                controller: _scrollController,
                itemCount: memos.items.length,
                itemBuilder: (ctx, index) => ListTile(
                  title: Text(memos.items[index].title),
                  subtitle: Text(memos.items[index].content),
                  onTap: () => Navigator.of(context).pushNamed(
                    '/memo',
                    arguments: memos.items[index],
                  ),
                ),
              ),
            );
          }
        });
  }
}
