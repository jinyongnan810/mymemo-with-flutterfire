import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/providers/search_memos_provider.dart';
import 'package:mymemo_with_flutterfire/shared/loading.dart';

class SearchResult extends ConsumerWidget {
  final String query;
  final VoidCallback close;
  const SearchResult({super.key, required this.query, required this.close});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memosFuture = ref.watch(searchMemosProvider(query));

    return memosFuture.when(
      data: (memos) {
        if (memos.isEmpty) {
          return const Center(
            child: Text('No memos found'),
          );
        }

        return ListView.builder(
          itemCount: memos.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(memos[index].title),
              onTap: () {
                context.go('/memos/${memos[index].id}');
                close.call();
              },
            );
          },
        );
      },
      error: (_, __) => const Center(
        child: Text('Error finding memos...'),
      ),
      loading: () => const Loading(),
    );
  }
}
