import 'package:flutter/material.dart';
import 'package:mymemo_with_flutterfire/components/memo-editor.dart';
import 'package:mymemo_with_flutterfire/components/memo-rendered.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';
import 'package:mymemo_with_flutterfire/providers/auth.dart';
import 'package:mymemo_with_flutterfire/providers/memos.dart';
import 'package:provider/provider.dart';

class MemoDetailPage extends StatefulWidget {
  final String id;
  const MemoDetailPage({Key? key, required this.id}) : super(key: key);
  static const routeName = '/detail';

  @override
  State<MemoDetailPage> createState() => _MemoDetailPageState();
}

class _MemoDetailPageState extends State<MemoDetailPage> {
  bool _editing = false;
  Memo? memo;
  @override
  void initState() {
    // use context in initState
    () async {
      await Future.delayed(Duration.zero);
      if (widget.id != 'new') {
        setState(() {
          memo =
              Provider.of<Memos>(context, listen: false).getItemById(widget.id);
        });
      } else {
        final auth = Provider.of<Auth>(context, listen: false);
        if (auth.signedIn) {
          setState(() {
            memo = Memo(title: '', content: '', userId: auth.userId);
            _editing = true;
          });
        }
      }
    }();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purple, Colors.orange])),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(memo?.title ?? 'Not found'),
            backgroundColor: Colors.transparent,
            elevation: 0,
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
                  ? MemoEditor(memo: memo!)
                  : MemoRendered(content: memo!.content),
          floatingActionButton: (memo == null ||
                  !auth.signedIn ||
                  memo!.userId != auth.userId)
              ? null
              : Container(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.purple, Colors.orange]),
                      borderRadius: BorderRadius.circular(30)),
                  child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    onPressed: () async {
                      if (_editing) {
                        try {
                          final isNewMemo = memo!.id == null;
                          await memo!.save();
                          if (isNewMemo) {
                            Provider.of<Memos>(context, listen: false)
                                .addItem(memo!);
                          } else {
                            Provider.of<Memos>(context, listen: false).notify();
                          }
                        } catch (e) {
                          print(Text(e.toString()));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Error saving memo.')));
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
                    child: _editing
                        ? const Icon(Icons.save)
                        : const Icon(Icons.edit),
                  ),
                ),
        ));
  }
}
