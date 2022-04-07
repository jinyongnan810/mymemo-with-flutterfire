import 'package:flutter/material.dart';
import 'package:mymemo_with_flutterfire/components/memo-editor.dart';
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
        body: memo == null
            ? const Center(
                child: Text('Memo not found.'),
              )
            : MemoEditor(memo: memo));
  }
}
