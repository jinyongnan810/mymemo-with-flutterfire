import 'package:flutter/material.dart';
import 'package:mymemo_with_flutterfire/components/search_results.dart';

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
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchResult(query: query, close: () => close(context, null));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
