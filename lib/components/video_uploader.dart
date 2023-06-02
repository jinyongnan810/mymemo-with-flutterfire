import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/components/file_dropper.dart';
import 'package:mymemo_with_flutterfire/providers/user_id_provider.dart';
import 'package:mymemo_with_flutterfire/utils/storage_util.dart';
import 'package:path/path.dart';

class VideoUploader extends ConsumerStatefulWidget {
  const VideoUploader({super.key});

  @override
  ConsumerState<VideoUploader> createState() => _VideoUploaderState();
}

class _VideoUploaderState extends ConsumerState<VideoUploader> {
  _FileAndName? _video;
  _FileAndName? _thumbnail;
  bool _isUploading = false;
  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(userIdProvider);

    return AlertDialog(
      title: const Text('Upload Video'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FileDropper(onDroppedFiles: onDroppedFiles),
          Text('Video: ${_video?.name ?? 'None'}'),
          Text('Thumbnail: ${_thumbnail?.name ?? 'None'}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isUploading
              ? null
              : () async {
                  final link = await upload(userId);
                  if (link == null) {
                    return;
                  }
                  debugPrint('link: $link');
                  if (!mounted) {
                    return;
                  }
                  Navigator.of(context).pop(link);
                },
          child: _isUploading
              ? const CircularProgressIndicator()
              : const Text('OK'),
        ),
        TextButton(
          onPressed: _isUploading ? null : () => Navigator.pop(context),
          child: _isUploading ? const SizedBox.shrink() : const Text('Cancel'),
        ),
      ],
    );
  }

  void onDroppedFiles(List<XFile> files) {
    // TODO: onDroppedFiles: [File: 'blob:http://localhost:1234/1e125af7-43ee-4d20-8199-50ddcb526e88', File: 'blob:http://localhost:1234/ec57b7a5-f60f-4875-93e3-92dc8d086544']
    debugPrint('onDroppedFiles: $files');
    final videos =
        files.where((file) => ['.mp4', '.mov'].any(file.name.endsWith));
    final pictures =
        files.where((file) => ['.png', '.jpg'].any(file.name.endsWith));
    debugPrint(videos.toString());
    debugPrint(pictures.toString());
    setState(() {
      _video = videos.isNotEmpty
          ? _FileAndName(File(videos.first.path), videos.first.name)
          : null;
      _thumbnail = pictures.isNotEmpty
          ? _FileAndName(File(pictures.first.path), pictures.first.name)
          : null;
    });
  }

  Future<String?> upload(String? userId) async {
    if (_video == null || _thumbnail == null || userId == null) {
      return null;
    }
    setState(() {
      _isUploading = true;
    });
    final videoExt = extension(_video!.name);
    final videoLink =
        await StorageUtil.upload(userId, _video!.file, videoExt, false);
    // TODO: handle failed
    final imageExt = extension(_thumbnail!.name);
    final thumbnailLink =
        await StorageUtil.upload(userId, _thumbnail!.file, imageExt, true);
    setState(() {
      _isUploading = false;
    });
    return '[![IMAGE]($thumbnailLink)]($videoLink)';
  }
}

class _FileAndName {
  _FileAndName(this.file, this.name);
  final File file;
  final String name;
}
