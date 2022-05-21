import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class CenteredHeaderBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SelectableText(
          text.text,
          style: preferredStyle,
          showCursor: true,
          toolbarOptions: const ToolbarOptions(copy: true),
        ),
      ],
    );
  }
}
