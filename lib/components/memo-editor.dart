import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymemo_with_flutterfire/components/code-builder.dart';
import 'package:mymemo_with_flutterfire/components/header-builder.dart';
import 'package:mymemo_with_flutterfire/components/memo-rendered.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mymemo_with_flutterfire/shared/markdown_extensions.dart';
import 'package:mymemo_with_flutterfire/shared/split.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  Future<void> _onPointerDown(PointerDownEvent event) async {
    // Check if right mouse button clicked
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      final overlay =
          Overlay.of(context)?.context.findRenderObject() as RenderBox;
      final menuItem = await showMenu<int>(
          context: context,
          items: [
            const PopupMenuItem(child: Text('Copy'), value: 1),
            const PopupMenuItem(child: Text('Cut'), value: 2),
          ],
          position: RelativeRect.fromSize(
              event.position & Size(48.0, 48.0), overlay.size));
      // Check if menu item clicked
      switch (menuItem) {
        case 1:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Copy clicket'),
          ));
          break;
        case 2:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Cut clicked'),
          ));
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
        },
        child: Actions(
            dispatcher: const ActionDispatcher(),
            actions: {
              MakeLinkIntent: MakeLinkAction(_contentEditor),
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
