import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// ignore: depend_on_referenced_packages
import 'package:markdown/markdown.dart' as md;

class CenteredHeaderBuilder extends MarkdownElementBuilder {
  CenteredHeaderBuilder({this.larger = false});
  final bool larger;
  @override
  // ignore: long-method
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: SelectableText(
        text.text,
        style: preferredStyle?.copyWith(
          fontSize: larger ? 40 : 24,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white,
          decorationStyle: TextDecorationStyle.double,
        ),
      ),
    );
  }
}
