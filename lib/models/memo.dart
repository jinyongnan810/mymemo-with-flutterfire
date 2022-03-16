import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Memo {
  String? id;
  String userId;
  String title;
  String content;
  int? createdAt;
  int? updatedAt;
  Memo(
      {this.id,
      required this.userId,
      required this.title,
      required this.content,
      this.createdAt,
      this.updatedAt});
  Future<void> save() async {
    if (kIsWeb || !Platform.isWindows) {
      print('not windows desktop');
      if (id == null) {
        print('create');
        final res = await FirebaseFirestore.instance.collection('memos').add({
          'userId': userId,
          'title': title,
          'content': content,
          'createdAt': DateTime.now().millisecondsSinceEpoch,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });
        print(res.id);
      } else {
        print('update');
      }
    } else if (Platform.isWindows) {
      print('windows desktop');
      if (id == null) {
        final url = Uri.parse(
            "https://firestore.googleapis.com/v1/projects/${dotenv.env['PROJECT_ID']}/databases/(default)/documents/memos");
        final res = await http.post(url,
            body: jsonEncode({
              'fields': {
                'userId': {'stringValue': userId},
                'title': {'stringValue': title},
                'content': {'stringValue': content},
                'createdAt': {
                  'integerValue': DateTime.now().millisecondsSinceEpoch
                },
                'updatedAt': {
                  'integerValue': DateTime.now().millisecondsSinceEpoch
                },
              }
            }));
        final Map<String, dynamic> decodedRes = jsonDecode(res.body);
        print(decodedRes['name'].toString().split('/').last);
      }
    }
  }
}
