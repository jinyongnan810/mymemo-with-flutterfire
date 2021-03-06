import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';
import 'package:mymemo_with_flutterfire/providers/memos.dart';
import 'package:mymemo_with_flutterfire/shared/loading.dart';

class MemoListSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: Memos.queryItems(query),
        builder: (ctx, AsyncSnapshot<List<Memo>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else {
            if (snapshot.error != null) {
              print(snapshot.error);
              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              //   content: Text('Error loading the memos.Please refresh again.'),
              //   duration: Duration(seconds: 5),
              // ));
              return Center(
                child: Text('error:${snapshot.error}'),
              );
            }
            List<Memo> data = snapshot.data!;
            if (data.isEmpty) {
              return const Center(
                child: Text('No memo found'),
              );
            }

            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index].title),
                    onTap: () {
                      GoRouter.of(context).go('/memos/${data[index].id}');
                      close(context, null);
                    },
                  );
                });
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
