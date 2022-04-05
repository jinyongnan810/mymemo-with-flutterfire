import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mymemo_with_flutterfire/providers/memos.dart';
import 'package:provider/provider.dart';

class MemoDetailPage extends StatelessWidget {
  const MemoDetailPage({Key? key}) : super(key: key);
  static const routeName = '/detail';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final memo = Provider.of<Memos>(context).getItemById(id);
    return Scaffold(
      appBar: AppBar(title: Text(memo?.title ?? 'Not found')),
      body: Column(children: [
        Center(child: Text(memo?.title ?? 'Not found')),
        Expanded(
            child: Markdown(
          data: memo?.content ?? '',
        ))
      ]),
    );
  }
}
