import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class CenteredHeaderBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Expanded(
              child: Divider(
            color: Colors.white,
            thickness: 2,
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SelectableText(
              text.text,
              style: preferredStyle,
              showCursor: true,
              toolbarOptions: const ToolbarOptions(copy: true),
            ),
          ),
          const Expanded(
              child: Divider(
            color: Colors.white,
            thickness: 2,
          )),
        ],
      ),
    );
  }
}
