import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Memo {
  String? id;
  String userId;
  String title;
  String content;
  int? createdAt;
  int? updatedAt;
  Memo({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory Memo.fromJsonRest(Map<String, dynamic> json) {
    return Memo(
      id: json['name'].toString().split('/').last,
      userId: json['fields']['userId']['stringValue'] as String,
      title: json['fields']['title']['stringValue'] as String,
      content: json['fields']['content']['stringValue'] as String,
      createdAt:
          int.parse(json['fields']['createdAt']['integerValue'].toString()),
      updatedAt:
          int.parse(json['fields']['updatedAt']['integerValue'].toString()),
    );
  }
  factory Memo.fromJson(String id, Map<String, dynamic> json) {
    return Memo(
      id: id,
      userId: json['userId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: json['createdAt'] as int,
      updatedAt: json['updatedAt'] as int,
    );
  }
  Future<void> save() async {
    // TODO: link with MemosNotifier
    final now = DateTime.now().millisecondsSinceEpoch;
    if (kIsWeb || !Platform.isWindows) {
      debugPrint('not windows desktop');
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
        debugPrint('created: $id');
      } else {
        await FirebaseFirestore.instance.collection('memos').doc(id).update({
          'title': title,
          'content': content,
          'updatedAt': now,
        });
        updatedAt = now;
        debugPrint('updated');
      }
    }
    /*else if (Platform.isWindows) {
      debugPrint('windows desktop');
      if (id == null) {
        final url = Uri.parse(
          "https://firestore.googleapis.com/v1/projects/${dotenv.env['PROJECT_ID']}/databases/(default)/documents/memos",
        );
        final res = await http.post(
          url,
          body: jsonEncode({
            'fields': {
              'userId': {'stringValue': userId},
              'title': {'stringValue': title},
              'content': {'stringValue': content},
              'createdAt': {'integerValue': now},
              'updatedAt': {'integerValue': now},
            },
          }),
        );
        final Map<String, dynamic> decodedRes =
            jsonDecode(res.body) as Map<String, dynamic>;
        id = decodedRes['name'].toString().split('/').last;
        createdAt = now;
        updatedAt = now;
        debugPrint('created $id');
      } else {
        final url = Uri.parse(
          "https://firestore.googleapis.com/v1/projects/${dotenv.env['PROJECT_ID']}/databases/(default)/documents/memos/$id?updateMask.fieldPaths=title&&updateMask.fieldPaths=content&&updateMask.fieldPaths=updatedAt",
        );
        await http.patch(
          url,
          body: jsonEncode({
            'fields': {
              'title': {'stringValue': title},
              'content': {'stringValue': content},
              'updatedAt': {'integerValue': now},
            },
          }),
        );
        updatedAt = now;
        debugPrint('updated');
      }
    }
    */
  }

  Future<void> delete() async {
    if (kIsWeb || !Platform.isWindows) {
      debugPrint('not windows desktop');
      await FirebaseFirestore.instance.collection('memos').doc(id).delete();
      debugPrint('deleted');
    }

    /*else if (Platform.isWindows) {
      debugPrint('windows desktop');

      final url = Uri.parse(
          "https://firestore.googleapis.com/v1/projects/${dotenv.env['PROJECT_ID']}/databases/(default)/documents/memos/$id");
      final res = await http.delete(url);
      debugPrint(jsonDecode(res.body));
      debugPrint('deleted');
    }*/
  }
}
