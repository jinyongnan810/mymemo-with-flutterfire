import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';

class Memos extends ChangeNotifier {
  static int itemsPerPage = 20;
  final List<Memo> _items = [];
  DocumentSnapshot? lastFetchedDocument;
  String? nextPageToken;
  List<Memo> get items {
    return [..._items];
  }

  Future<Memo?> getItemById(String id) async {
    final memoMatched = _items.where((element) => element.id == id);
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

  void addItem(Memo memo) {
    _items.insert(0, memo);
    notifyListeners();
  }

  void deleteItem(Memo memo) {
    _items.removeWhere((item) => item.id == memo.id);
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  static Future<List<Memo>> queryItems(String query) async {
    print('queryItems:$query');
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
