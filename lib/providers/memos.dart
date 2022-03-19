import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mymemo_with_flutterfire/models/memo.dart';

class Memos extends ChangeNotifier {
  final int itemsPerPage = 5;
  final List<Memo> _items = [];
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
    _items.addAll(memos);
    notifyListeners();
  }
}
