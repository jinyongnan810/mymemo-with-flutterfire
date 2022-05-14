import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mymemo_with_flutterfire/components/code-builder.dart';
import 'package:mymemo_with_flutterfire/components/header-builder.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';
import 'package:mymemo_with_flutterfire/shared/markdown_extensions.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MemoRendered extends StatelessWidget {
  final Memo memo;
  const MemoRendered({Key? key, required this.memo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Markdown(
      // extensionSet: MarkdownExtensionSet.githubWeb.value,
      styleSheet: MarkdownStyleSheet.fromTheme(
          Theme.of(context).copyWith(cardColor: Colors.transparent)),
      data: memo.content,
      onTapLink: (text, url, title) {
        url != null ? launchUrlString(url) : null;
      },
      builders: {
        'code': CodeBuilder(),
        'h1': CenteredHeaderBuilder(),
        'h2': CenteredHeaderBuilder(),
        'h3': CenteredHeaderBuilder(),
        'h4': CenteredHeaderBuilder(),
        'h5': CenteredHeaderBuilder(),
        'h6': CenteredHeaderBuilder(),
      },
    );
  }
}
