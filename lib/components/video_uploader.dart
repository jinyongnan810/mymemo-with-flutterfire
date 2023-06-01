import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:mymemo_with_flutterfire/components/file_dropper.dart';

class VideoUploader extends StatefulWidget {
  const VideoUploader({super.key});

  @override
  State<VideoUploader> createState() => _VideoUploaderState();
}

class _VideoUploaderState extends State<VideoUploader> {
  _FileAndName? _video;
  _FileAndName? _thumbnail;
  final bool _isUploading = false;
  @override
  Widget build(BuildContext context) {
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
}

class _FileAndName {
  _FileAndName(this.file, this.name);
  final File file;
  final String name;
}
