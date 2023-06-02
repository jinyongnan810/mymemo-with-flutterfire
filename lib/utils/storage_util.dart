import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class StorageUtil {
  static Future<String?> upload(
    String userId,
    File file,
    String ext,
    bool isImage,
  ) async {
    final uuid = const Uuid().v4();
    final ref = FirebaseStorage.instance.ref('uploads/$userId/$uuid$ext');
    try {
      await ref.putFile(
        file,
        SettableMetadata(contentType: isImage ? 'image/*' : 'video/*'),
      );
      final downloadLink = await ref.getDownloadURL();

      return downloadLink;
    } catch (e) {
      // TODO: getting Platform._operatingSystem
      debugPrint(e.toString());
    }
    return null;
  }
}
