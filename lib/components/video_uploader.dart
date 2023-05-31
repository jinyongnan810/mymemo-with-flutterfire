import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mymemo_with_flutterfire/components/file_dropper.dart';

class VideoUploader extends StatefulWidget {
  const VideoUploader({super.key});

  @override
  State<VideoUploader> createState() => _VideoUploaderState();
}

class _VideoUploaderState extends State<VideoUploader> {
  File? _video;
  File? _thumbnail;
  final bool _isUploading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Upload Video'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FileDropper(onDroppedFiles: onDroppedFiles),
          Text('Video: ${_video?.path ?? 'None'}'),
          Text('Thumbnail: ${_thumbnail?.path ?? 'None'}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  void onDroppedFiles(List<File> files) {
    // TODO: onDroppedFiles: [File: 'blob:http://localhost:1234/1e125af7-43ee-4d20-8199-50ddcb526e88', File: 'blob:http://localhost:1234/ec57b7a5-f60f-4875-93e3-92dc8d086544']
    debugPrint('onDroppedFiles: $files');
    final videos =
        files.where((file) => ['.mp4', '.mov'].any(file.path.endsWith));
    final pictures =
        files.where((file) => ['.png', '.jpg'].any(file.path.endsWith));
    debugPrint(videos.toString());
    debugPrint(pictures.toString());
    setState(() {
      _video = videos.isNotEmpty ? videos.first : null;
      _thumbnail = pictures.isNotEmpty ? pictures.first : null;
    });
  }
}
