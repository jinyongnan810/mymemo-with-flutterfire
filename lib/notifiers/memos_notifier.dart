import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';

class MemosNotifier extends StateNotifier<List<Memo>> {
  static int itemsPerPage = 20;
  DocumentSnapshot? lastFetchedDocument;
  String? nextPageToken;
  MemosNotifier() : super([]);

  Future<void> fetchFirstItems() async {
    state.clear();
    debugPrint('fetchFirstItems');
    final res = await FirebaseFirestore.instance
        .collection('memos')
        .orderBy('updatedAt', descending: true)
        .limit(itemsPerPage)
        .get();
    if (res.docs.isEmpty) {
      lastFetchedDocument = null;

      return;
    }
    final memos = res.docs.map<Memo>((doc) {
      final docData = doc.data();
      final Memo memo = Memo.fromJson(doc.id, docData);

      return memo;
    });
    lastFetchedDocument = res.docs.last;
    state.addAll(memos);
  }

  Future<void> fetchNextItems() async {
    debugPrint('fetchNextItems');
    if (lastFetchedDocument == null) {
      debugPrint('lastFetchedDocument is null');

      return;
    }
    QuerySnapshot<Map<String, dynamic>> res = await FirebaseFirestore.instance
        .collection('memos')
        .orderBy('updatedAt', descending: true)
        .startAfterDocument(lastFetchedDocument!)
        .limit(itemsPerPage)
        .get();
    if (res.docs.isEmpty) {
      lastFetchedDocument = null;

      return;
    }
    final memos = res.docs.map<Memo>((doc) {
      final docData = doc.data();
      final Memo memo = Memo.fromJson(doc.id, docData);

      return memo;
    });
    lastFetchedDocument = res.docs.last;
    state.addAll(memos);
  }

  Future<Memo?> getItemById(String id) async {
    final memoMatched = state.where((element) => element.id == id);
    if (memoMatched.isEmpty) {
      final memoSnapshot =
          await FirebaseFirestore.instance.collection('memos').doc(id).get();
      if (memoSnapshot.exists) {
        final Memo memo = Memo.fromJson(id, memoSnapshot.data()!);

        return memo;
      }

      return null;
    }

    return memoMatched.first;
  }
}
