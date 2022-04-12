import 'package:flutter/material.dart';
import 'package:mymemo_with_flutterfire/components/memo-editor.dart';
import 'package:mymemo_with_flutterfire/components/memo-rendered.dart';
import 'package:mymemo_with_flutterfire/providers/memos.dart';
import 'package:provider/provider.dart';

class MemoDetailPage extends StatefulWidget {
  const MemoDetailPage({Key? key}) : super(key: key);
  static const routeName = '/detail';

  @override
  State<MemoDetailPage> createState() => _MemoDetailPageState();
}

class _MemoDetailPageState extends State<MemoDetailPage> {
  bool _editing = false;
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final memo = Provider.of<Memos>(context).getItemById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(memo?.title ?? 'Not found'),
        // leading: Builder(
        //   builder: ((context) => IconButton(
        //       onPressed: () {
        //         Navigator.of(context).pushReplacementNamed('/');
        //       },
        //       icon: const Icon(Icons.home))),
        // ),
      ),
      body: memo == null
          ? const Center(
              child: Text('Memo not found.'),
            )
          : _editing
              ? MemoEditor(memo: memo)
              : MemoRendered(memo: memo),
      floatingActionButton: memo == null
          ? null
          : FloatingActionButton(
              onPressed: () async {
                if (_editing) {
                  try {
                    await memo.save();
                  } catch (e) {
                    print(Text(e.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error saving memo.')));
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Memo saved.')));
                  setState(() {
                    _editing = false;
                  });
                } else {
                  setState(() {
                    _editing = true;
                  });
                }
              },
              child: _editing ? const Icon(Icons.save) : const Icon(Icons.edit),
            ),
    );
  }
}
