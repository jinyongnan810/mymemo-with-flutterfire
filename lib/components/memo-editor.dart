import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymemo_with_flutterfire/components/memo-rendered.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';
import 'package:mymemo_with_flutterfire/providers/auth.dart';
import 'package:mymemo_with_flutterfire/shared/split.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MakeLinkIntent extends Intent {
  const MakeLinkIntent();
}

class MakeLinkAction extends Action<MakeLinkIntent> {
  final TextEditingController controller;
  MakeLinkAction(this.controller);
  @override
  void invoke(MakeLinkIntent intent) {
    final subString = controller.text.substring(
        controller.selection.baseOffset, controller.selection.extentOffset);
    final replaceString = '[$subString]()';
    final baseOffset = controller.selection.baseOffset;
    controller.text = controller.text.replaceRange(
        controller.selection.baseOffset,
        controller.selection.extentOffset,
        replaceString);
    final newOffset = subString.isEmpty
        ? baseOffset + replaceString.length - 3
        : baseOffset + replaceString.length - 1;
    controller.selection = TextSelection.collapsed(offset: newOffset);
  }
}

class PressEnterIntent extends Intent {
  const PressEnterIntent();
}

class PressEnterAction extends Action<PressEnterIntent> {
  final TextEditingController controller;
  PressEnterAction(this.controller);
  @override
  void invoke(PressEnterIntent intent) {
    final pos = controller.selection.baseOffset;
    final sofar = controller.text.substring(0, pos);
    LineSplitter ls = const LineSplitter();
    List<String> linesSoFar = ls.convert(sofar);
    final currentLine = linesSoFar.last;
    final String replaceString;
    if (RegExp(r'^\- ').hasMatch(currentLine)) {
      replaceString = '\r\n' '- \r\n';
    } else {
      replaceString = '\r\n';
    }
    controller.text = controller.text.replaceRange(
        controller.selection.baseOffset,
        controller.selection.baseOffset + 1,
        replaceString);
    final newOffset = pos + 3;
    controller.selection = TextSelection.collapsed(offset: newOffset);
  }
}

class MemoEditor extends StatefulWidget {
  final Memo memo;

  const MemoEditor({Key? key, required this.memo}) : super(key: key);

  @override
  State<MemoEditor> createState() => _MemoEditorState();
}

class _MemoEditorState extends State<MemoEditor> {
  String _title = '';
  String _content = '';
  final TextEditingController _titleEditor = TextEditingController();
  final TextEditingController _contentEditor = TextEditingController();
  @override
  void initState() {
    _title = widget.memo.title;
    _titleEditor.text = widget.memo.title;
    _content = widget.memo.content;
    _contentEditor.text = widget.memo.content;
    _contentEditor.addListener(() {
      setState(() {
        _content = _contentEditor.text;
      });
      widget.memo.content = _content;
    });
    _titleEditor.addListener(() {
      setState(() {
        _title = _titleEditor.text;
      });
      widget.memo.title = _title;
    });
    super.initState();
  }

  @override
  void dispose() {
    _titleEditor.dispose();
    _contentEditor.dispose();
    super.dispose();
  }

  void _insertImage(String url) async {
    String subString = _contentEditor.text.substring(
        _contentEditor.selection.baseOffset,
        _contentEditor.selection.extentOffset);
    if (subString.isEmpty) subString = 'image';
    final replaceString = '![$subString]($url)';
    final baseOffset = _contentEditor.selection.baseOffset;
    _contentEditor.text = _contentEditor.text.replaceRange(
        _contentEditor.selection.baseOffset,
        _contentEditor.selection.extentOffset,
        replaceString);
    final newOffset = baseOffset + replaceString.length;
    _contentEditor.selection = TextSelection.collapsed(offset: newOffset);
  }

  Future<void> _onPointerDown(PointerDownEvent event) async {
    // Check if right mouse button clicked
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      final overlay =
          Overlay.of(context)?.context.findRenderObject() as RenderBox;
      final menuItem = await showMenu<int>(
          context: context,
          items: [
            const PopupMenuItem(child: Text('Upload'), value: 1),
          ],
          position: RelativeRect.fromSize(
              event.position & const Size(48.0, 48.0), overlay.size));
      // Check if menu item clicked
      switch (menuItem) {
        case 1:
          final result = await FilePicker.platform.pickFiles();
          if (result != null) {
            final fileBytes = result.files.first.bytes;
            final ext = result.files.first.extension;
            final fileName = result.files.first.name;
            final userId = Provider.of<Auth>(context, listen: false).userId;
            final uuid = const Uuid().v4();
            final ref =
                FirebaseStorage.instance.ref('uploads/$userId/$uuid.$ext');
            try {
              await ref.putData(
                  fileBytes!, SettableMetadata(contentType: 'image/*'));
              final downloadLink = await ref.getDownloadURL();
              _insertImage(downloadLink);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Successfully uploaded $fileName'),
              ));
              print(downloadLink);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Failed to upload $fileName'),
              ));
              print(e);
            }
          }
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyL):
              const MakeLinkIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.enter):
              const PressEnterIntent(),
        },
        child: Actions(
            dispatcher: const ActionDispatcher(),
            actions: {
              PressEnterIntent: PressEnterAction(_contentEditor),
            },
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: TextField(
                    controller: _titleEditor,
                    decoration: const InputDecoration(
                      hintText: 'Enter title',
                    ),
                    textAlign: TextAlign.center,
                  )),
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Split(
                    axis: Axis.horizontal,
                    initialFirstFraction: 0.5,
                    firstChild: Listener(
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: _contentEditor,
                        decoration: const InputDecoration(
                          hintText: 'Enter contents in Markdown',
                        ),
                      ),
                      onPointerDown: _onPointerDown,
                    ),
                    secondChild: MemoRendered(
                      content: _content,
                      withPadding: false,
                    )),
              ))
            ])));
  }
}
