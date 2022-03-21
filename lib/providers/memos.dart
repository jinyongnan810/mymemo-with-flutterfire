import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mymemo_with_flutterfire/models/memo.dart';

class Memos extends ChangeNotifier {
  final int itemsPerPage = 20;
  final List<Memo> _items = [];
  DocumentSnapshot? lastFetchedDocument;
  get items {
    return [..._items];
  }

  Future<void> fetchFirstItems() async {
    _items.clear();
    QuerySnapshot<Map<String, dynamic>> res = await FirebaseFirestore.instance
        .collection('memos')
        .orderBy('updatedAt')
        .limit(itemsPerPage)
        .get();

    final memos = res.docs.map<Memo>((doc) {
      final docData = doc.data();
      print(docData);
      final Memo memo = Memo(
          id: doc.id,
          userId: docData['userId'],
          title: docData['title'],
          content: docData['content'],
          createdAt: docData['createdAt'],
          updatedAt: docData['updatedAt']);
      return memo;
    });
    lastFetchedDocument = res.docs.last;
    _items.addAll(memos);
    notifyListeners();
  }

  Future<void> fetchNextItems() async {
    QuerySnapshot<Map<String, dynamic>> res = await FirebaseFirestore.instance
        .collection('memos')
        .orderBy('updatedAt')
        .startAfterDocument(lastFetchedDocument!)
        .limit(itemsPerPage)
        .get();
    if (res.docs.isNotEmpty) {
      final memos = res.docs.map<Memo>((doc) {
        final docData = doc.data();
        print(docData);
        final Memo memo = Memo(
            id: doc.id,
            userId: docData['userId'],
            title: docData['title'],
            content: docData['content'],
            createdAt: docData['createdAt'],
            updatedAt: docData['updatedAt']);
        return memo;
      });
      lastFetchedDocument = res.docs.last;
      _items.addAll(memos);
      notifyListeners();
    }
  }
}
