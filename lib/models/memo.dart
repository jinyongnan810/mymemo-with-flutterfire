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
    final now = DateTime.now().millisecondsSinceEpoch;
    if (kIsWeb || !Platform.isWindows) {
      print('not windows desktop');
      if (id == null) {
        final res = await FirebaseFirestore.instance.collection('memos').add({
          'userId': userId,
          'title': title,
          'content': content,
          'createdAt': now,
          'updatedAt': now,
        });
        id = res.id;
        createdAt = now;
        updatedAt = now;
        print('created: $id');
      } else {
        await FirebaseFirestore.instance.collection('memos').doc(id).update({
          'title': title,
          'content': content,
          'updatedAt': now,
        });
        updatedAt = now;
        print('updated');
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
                'createdAt': {'integerValue': now},
                'updatedAt': {'integerValue': now},
              }
            }));
        final Map<String, dynamic> decodedRes = jsonDecode(res.body);
        id = decodedRes['name'].toString().split('/').last;
        createdAt = now;
        updatedAt = now;
        print('created $id');
      } else {
        final url = Uri.parse(
            "https://firestore.googleapis.com/v1/projects/${dotenv.env['PROJECT_ID']}/databases/(default)/documents/memos/$id?updateMask.fieldPaths=title&&updateMask.fieldPaths=content&&updateMask.fieldPaths=updatedAt");
        final res = await http.patch(url,
            body: jsonEncode({
              'fields': {
                'title': {'stringValue': title},
                'content': {'stringValue': content},
                'updatedAt': {'integerValue': now},
              }
            }));
        updatedAt = now;
        print('updated');
      }
    }
  }
}
