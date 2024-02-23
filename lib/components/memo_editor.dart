// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/components/memo_rendered.dart';
import 'package:mymemo_with_flutterfire/components/video_uploader.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';
import 'package:mymemo_with_flutterfire/providers/user_id_provider.dart';
import 'package:mymemo_with_flutterfire/shared/split.dart';
import 'package:mymemo_with_flutterfire/typedef.dart';
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
      controller.selection.baseOffset,
      controller.selection.extentOffset,
    );
    final replaceString = '[$subString]()';
    final baseOffset = controller.selection.baseOffset;
    controller.text = controller.text.replaceRange(
      controller.selection.baseOffset,
      controller.selection.extentOffset,
      replaceString,
    );
    final newOffset = subString.isEmpty
        ? baseOffset + replaceString.length - 3
        : baseOffset + replaceString.length - 1;
    controller.selection = TextSelection.collapsed(offset: newOffset);
  }
}

class MakeBoldIntent extends Intent {
  const MakeBoldIntent();
}

class MakeBoldAction extends Action<MakeBoldIntent> {
  final TextEditingController controller;
  MakeBoldAction(this.controller);
  @override
  void invoke(MakeBoldIntent intent) {
    final subString = controller.text.substring(
      controller.selection.baseOffset,
      controller.selection.extentOffset,
    );
    final replaceString = '**$subString**';
    final baseOffset = controller.selection.baseOffset;
    controller.text = controller.text.replaceRange(
      controller.selection.baseOffset,
      controller.selection.extentOffset,
      replaceString,
    );
    final newOffset = subString.isEmpty
        ? baseOffset + replaceString.length - 2
        : baseOffset + replaceString.length;
    controller.selection = TextSelection.collapsed(offset: newOffset);
  }
}

class MakeItalicIntent extends Intent {
  const MakeItalicIntent();
}

class MakeItalicAction extends Action<MakeItalicIntent> {
  final TextEditingController controller;
  MakeItalicAction(this.controller);
  @override
  void invoke(MakeItalicIntent intent) {
    final subString = controller.text.substring(
      controller.selection.baseOffset,
      controller.selection.extentOffset,
    );
    final replaceString = '*$subString*';
    final baseOffset = controller.selection.baseOffset;
    controller.text = controller.text.replaceRange(
      controller.selection.baseOffset,
      controller.selection.extentOffset,
      replaceString,
    );
    final newOffset = subString.isEmpty
        ? baseOffset + replaceString.length - 1
        : baseOffset + replaceString.length;
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
    replaceString =
        RegExp(r'^\- ').hasMatch(currentLine) ? '\r\n' '- \r\n' : '\r\n';
    controller.text = controller.text.replaceRange(
      controller.selection.baseOffset,
      controller.selection.baseOffset + 1,
      replaceString,
    );
    final newOffset = pos + 3;
    controller.selection = TextSelection.collapsed(offset: newOffset);
  }
}

class MemoEditor extends HookConsumerWidget {
  final Memo memo;

  const MemoEditor({super.key, required this.memo});

  void _insert(String markdown, TextEditingController contentEditor) async {
    final replaceString = '$markdown\n';
    final baseOffset = contentEditor.selection.baseOffset;
    contentEditor.text = contentEditor.text.replaceRange(
      contentEditor.selection.baseOffset,
      contentEditor.selection.extentOffset,
      replaceString,
    );
    final newOffset = baseOffset + replaceString.length;
    contentEditor.selection = TextSelection.collapsed(offset: newOffset);
  }

  void _insertImage(String url, TextEditingController contentEditor) async {
    String subString = contentEditor.text.substring(
      contentEditor.selection.baseOffset,
      contentEditor.selection.extentOffset,
    );
    if (subString.isEmpty) subString = 'image';
    final replaceString = '![$subString]($url)';
    final baseOffset = contentEditor.selection.baseOffset;
    contentEditor.text = contentEditor.text.replaceRange(
      contentEditor.selection.baseOffset,
      contentEditor.selection.extentOffset,
      replaceString,
    );
    final newOffset = baseOffset + replaceString.length;
    contentEditor.selection = TextSelection.collapsed(offset: newOffset);
  }

  // ignore: long-method
  Future<void> _onPointerDown(
    PointerDownEvent event,
    BuildContext context,
    TextEditingController contentEditor,
    UserId? userId,
  ) async {
    // Check if right mouse button clicked
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      if (userId == null) {
        return;
      }
      final overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;
      final menuItem = await showMenu<int>(
        context: context,
        items: [
          const PopupMenuItem(value: 1, child: Text('Upload Image')),
          const PopupMenuItem(value: 2, child: Text('Upload Video')),
        ],
        position: RelativeRect.fromSize(
          event.position & const Size(48.0, 48.0),
          overlay.size,
        ),
      );
      // Check if menu item clicked
      switch (menuItem) {
        case 1:
          final result = await FilePicker.platform.pickFiles();
          if (result != null) {
            final fileBytes = result.files.first.bytes;
            final ext = result.files.first.extension;
            final fileName = result.files.first.name;
            final uuid = const Uuid().v4();
            final ref =
                FirebaseStorage.instance.ref('uploads/$userId/$uuid.$ext');
            try {
              await ref.putData(
                fileBytes!,
                SettableMetadata(contentType: 'image/*'),
              );
              final downloadLink = await ref.getDownloadURL();
              _insertImage(downloadLink, contentEditor);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Successfully uploaded $fileName'),
              ));
              debugPrint(downloadLink);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Failed to upload $fileName'),
              ));
              debugPrint(e.toString());
            }
          }
          break;
        case 2:
          final markdown = await showDialog<String?>(
            context: context,
            barrierDismissible: true,
            builder: (ctx) {
              return const VideoUploader();
            },
          );
          if (markdown == null) {
            return;
          }
          _insert(markdown, contentEditor);
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.read(userIdProvider);
    final titleEditor = useTextEditingController(text: memo.title);
    final contentEditor = useTextEditingController(text: memo.content);
    final title = useState(titleEditor.text);
    final content = useState(contentEditor.text);
    useEffect(
      () {
        titleEditor.addListener(() {
          title.value = titleEditor.text;
          memo.title = title.value;
        });
        contentEditor.addListener(() {
          content.value = contentEditor.text;
          memo.content = content.value;
        });

        return null;
      },
      [titleEditor, contentEditor],
    );

    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyL):
            const MakeLinkIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyB):
            const MakeBoldIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyI):
            const MakeItalicIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.enter):
            const PressEnterIntent(),
      },
      child: Actions(
        dispatcher: const ActionDispatcher(),
        actions: {
          MakeLinkIntent: MakeLinkAction(contentEditor),
          MakeBoldIntent: MakeBoldAction(contentEditor),
          MakeItalicIntent: MakeItalicAction(contentEditor),
          PressEnterIntent: PressEnterAction(contentEditor),
        },
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: TextField(
              controller: titleEditor,
              decoration: const InputDecoration(
                hintText: 'Enter title',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Split(
                axis: Axis.horizontal,
                initialFirstFraction: 0.5,
                firstChild: Listener(
                  onPointerDown: (e) =>
                      _onPointerDown(e, context, contentEditor, userId),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: contentEditor,
                    decoration: const InputDecoration(
                      hintText: 'Enter contents in Markdown',
                    ),
                  ),
                ),
                secondChild: MemoRendered(
                  content: content.value,
                  withPadding: false,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
