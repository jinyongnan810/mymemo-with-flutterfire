import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';

class Memos extends ChangeNotifier {
  final int itemsPerPage = 20;
  final List<Memo> _items = [];
  DocumentSnapshot? lastFetchedDocument;
  String? nextPageToken;
  List<Memo> get items {
    return [..._items];
  }

  Memo? getItemById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addItem(Memo memo) {
    _items.insert(0, memo);
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  Future<void> fetchFirstItems() async {
    _items.clear();
    if (kIsWeb || !Platform.isWindows) {
      print('fetchFirstItems not windows desktop');
      QuerySnapshot<Map<String, dynamic>> res = await FirebaseFirestore.instance
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
      _items.addAll(memos);
      notifyListeners();
    } else if (Platform.isWindows) {
      print('fetchFirstItems windows desktop');
      final url = Uri.parse(
          "https://firestore.googleapis.com/v1/projects/${dotenv.env['PROJECT_ID']}/databases/(default)/documents/memos?pageSize=$itemsPerPage&orderBy=updatedAt desc");
      final res = await http.get(url);
      final Map<String, dynamic> decodedRes = jsonDecode(res.body);
      if (decodedRes['documents'] == null) {
        nextPageToken = null;
        return;
      }
      final memos = (decodedRes['documents'] as List<dynamic>).map((doc) {
        return Memo.fromJsonRest(doc);
      });
      print(memos);
      nextPageToken = decodedRes['nextPageToken'];
      _items.addAll(memos);
      notifyListeners();
    }
  }

  Future<void> fetchNextItems() async {
    if (kIsWeb || !Platform.isWindows) {
      print('fetchNextItems not windows desktop');
      if (lastFetchedDocument == null) {
        print('lastFetchedDocument is null');
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
      _items.addAll(memos);
      notifyListeners();
    } else if (Platform.isWindows) {
      print('fetchNextItems windows desktop');
      if (nextPageToken == null) {
        print('nextPageToken is null');
        return;
      }
      final url = Uri.parse(
          "https://firestore.googleapis.com/v1/projects/${dotenv.env['PROJECT_ID']}/databases/(default)/documents/memos?pageSize=$itemsPerPage&orderBy=updatedAt desc&pageToken=$nextPageToken");
      final res = await http.get(url);
      final Map<String, dynamic> decodedRes = jsonDecode(res.body);
      if (decodedRes['documents'] == null) {
        nextPageToken = null;
        return;
      }
      ;
      final memos = (decodedRes['documents'] as List<dynamic>).map((doc) {
        return Memo.fromJsonRest(doc);
      });
      nextPageToken = decodedRes['nextPageToken'];
      _items.addAll(memos);
      notifyListeners();
    }
  }
}
