import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';

final searchMemosProvider =
    FutureProvider.autoDispose.family<List<Memo>, String>((ref, query) async {
  debugPrint('queryItems:$query');
  QuerySnapshot<Map<String, dynamic>> res = await FirebaseFirestore.instance
      .collection('memos')
      .orderBy('updatedAt', descending: true)
      .get();
  if (res.docs.isEmpty) {
    return [];
  }
  final memos = res.docs.map<Memo>((doc) {
    final docData = doc.data();
    final Memo memo = Memo.fromJson(doc.id, docData);

    return memo;
  }).toList();

  return memos.where((memo) {
    return memo.title.contains(RegExp(query, caseSensitive: false)) ||
        memo.content.contains(RegExp(query, caseSensitive: false));
  }).toList();
});
