import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';

class MemosState {
  final bool isLoading;
  final List<Memo> memos;

  MemosState({required this.isLoading, required this.memos});
  MemosState copyWithIsLoading(bool isLoading) =>
      MemosState(memos: memos, isLoading: isLoading);
}

class MemosNotifier extends StateNotifier<MemosState> {
  static int itemsPerPage = 20;
  DocumentSnapshot? lastFetchedDocument;
  String? nextPageToken;
  MemosNotifier() : super(MemosState(isLoading: false, memos: []));

  Future<void> fetchFirstItems() async {
    state = MemosState(isLoading: true, memos: []);
    debugPrint('fetchFirstItems');
    final res = await FirebaseFirestore.instance
        .collection('memos')
        .orderBy('updatedAt', descending: true)
        .limit(itemsPerPage)
        .get();
    if (res.docs.isEmpty) {
      lastFetchedDocument = null;
      state = MemosState(isLoading: false, memos: []);

      return;
    }
    final memos = res.docs.map<Memo>((doc) {
      final docData = doc.data();
      final Memo memo = Memo.fromJson(doc.id, docData);

      return memo;
    });
    lastFetchedDocument = res.docs.last;
    state = MemosState(isLoading: false, memos: [...state.memos, ...memos]);
  }

  Future<void> fetchNextItems() async {
    debugPrint('fetchNextItems');
    state = state.copyWithIsLoading(true);
    if (lastFetchedDocument == null) {
      debugPrint('lastFetchedDocument is null');
      state = state.copyWithIsLoading(false);

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
    state = MemosState(isLoading: false, memos: [...state.memos, ...memos]);
  }

  Future<Memo?> getItemById(String id) async {
    // FIXME: cannot set state
    // state = state.copyWithIsLoading(true);
    try {
      final memoMatched = state.memos.where((element) => element.id == id);
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
    } catch (e) {
      debugPrint('Error fetching memo $id');

      return null;
    }
  }

  void addItem(Memo memo) {
    state =
        MemosState(isLoading: state.isLoading, memos: [memo, ...state.memos]);
  }

  void updateItem(Memo memo) {
    state = MemosState(
      isLoading: state.isLoading,
      memos: [memo, ...state.memos.where((m) => m.id != memo.id)],
    );
  }

  void deleteItem(Memo memo) {
    state = MemosState(
      isLoading: state.isLoading,
      memos: state.memos.where((m) => m.id != memo.id).toList(),
    );
  }
}
