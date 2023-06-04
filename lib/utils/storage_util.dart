// ignore: depend_on_referenced_packages
import 'package:cross_file/cross_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class StorageUtil {
  static Future<String?> upload(
    String userId,
    XFile file,
    String ext,
    bool isImage,
  ) async {
    final uuid = const Uuid().v4();
    final ref = FirebaseStorage.instance.ref('uploads/$userId/$uuid$ext');
    final bytes = await file.readAsBytes();
    try {
      await ref.putData(
        bytes,
        SettableMetadata(
          contentType: isImage ? 'image/*' : 'video/*',
          customMetadata: {'picked-file-path': file.path},
        ),
      );
      final downloadLink = await ref.getDownloadURL();

      return downloadLink;
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }
}
