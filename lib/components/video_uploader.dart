import 'dart:io';

import 'package:flutter/material.dart';

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
      content: const Text('Not implemented yet'),
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
}
