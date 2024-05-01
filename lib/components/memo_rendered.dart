import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mymemo_with_flutterfire/components/code_builder.dart';
import 'package:mymemo_with_flutterfire/components/header_builder.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MemoRendered extends StatelessWidget {
  final String content;
  final bool withPadding;
  const MemoRendered({
    super.key,
    required this.content,
    this.withPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: withPadding ? const EdgeInsets.only(top: 30) : EdgeInsets.zero,
      child: Markdown(
        // extensionSet: MarkdownExtensionSet.githubWeb.value,
        styleSheet: MarkdownStyleSheet.fromTheme(
          Theme.of(context).copyWith(
            cardColor: Colors.transparent,
            textTheme: Theme.of(context).textTheme.copyWith(
                  bodyMedium: const TextStyle(fontSize: 20),
                ),
          ),
        ),
        data: content,
        onTapLink: (text, url, title) {
          if (url == null) {
            return;
          }
          if (url.startsWith('https://firebasestorage.googleapis.com'
              '/v0/b/mymemo-98f76.appspot.com/o/uploads')) {
            final prefixAndRest = url.split('uploads');
            if (prefixAndRest.length != 2) {
              return;
            }
            final prefix = '${prefixAndRest[0]}uploads';
            final rest = prefixAndRest[1].replaceAll('/', '%2F');
            launchUrlString(prefix + rest);

            return;
          }
          launchUrlString(url);
        },
        selectable: true,
        builders: {
          'code': CodeBuilder(),
          'h1': CenteredHeaderBuilder(larger: true),
          'h2': CenteredHeaderBuilder(),
        },
        imageBuilder: (uri, title, alt) {
          return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(uri.toString()),
            ),
          );
        },
        softLineBreak: true,
      ),
    );
  }
}
