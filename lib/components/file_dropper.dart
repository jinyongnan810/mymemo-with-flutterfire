// ignore: depend_on_referenced_packages
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class FileDropper extends StatelessWidget {
  const FileDropper({super.key, required this.onDroppedFiles});
  final void Function(List<XFile>) onDroppedFiles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        dashPattern: const [20, 8],
        color: Colors.white,
        strokeWidth: 5,
        strokeCap: StrokeCap.round,
        borderType: BorderType.RRect,
        radius: const Radius.circular(20),
        child: DropTarget(
          onDragDone: (details) {
            final files = details.files;
            onDroppedFiles(files);
          },
          onDragEntered: (details) {},
          onDragExited: (details) {},
          child: const SizedBox(
            width: 300,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Drag and drop video&thumbnail here',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
