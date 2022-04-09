import 'package:flutter/material.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mymemo_with_flutterfire/shared/markdown_extensions.dart';
import 'package:mymemo_with_flutterfire/shared/split.dart';

class MemoEditor extends StatefulWidget {
  final Memo memo;

  const MemoEditor({Key? key, required this.memo}) : super(key: key);

  @override
  State<MemoEditor> createState() => _MemoEditorState();
}

class _MemoEditorState extends State<MemoEditor> {
  String _title = '';
  String _content = '';
  final TextEditingController _contentEditor = TextEditingController();
  @override
  void initState() {
    _title = widget.memo.title;
    _contentEditor.text = widget.memo.content;
    _content = widget.memo.content;
    _contentEditor.addListener(() {
      setState(() {
        _content = _contentEditor.text;
      });
      widget.memo.content = _content;
    });
    super.initState();
  }

  @override
  void dispose() {
    _contentEditor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(child: Text(_title)),
      Expanded(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Split(
            axis: Axis.horizontal,
            initialFirstFraction: 0.5,
            firstChild: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _contentEditor,
            ),
            secondChild: Markdown(
              extensionSet: MarkdownExtensionSet.githubWeb.value,
              data: _content,
            )),
      ))
    ]);
  }
}
