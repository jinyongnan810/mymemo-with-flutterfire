import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mymemo_with_flutterfire/components/code-builder.dart';
import 'package:mymemo_with_flutterfire/components/header-builder.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';
import 'package:mymemo_with_flutterfire/shared/markdown_extensions.dart';

class MemoRendered extends StatelessWidget {
  final Memo memo;
  const MemoRendered({Key? key, required this.memo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Markdown(
      extensionSet: MarkdownExtensionSet.githubWeb.value,
      data: memo.content,
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
