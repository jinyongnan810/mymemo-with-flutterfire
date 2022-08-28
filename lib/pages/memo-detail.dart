import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mymemo_with_flutterfire/components/memo-editor.dart';
import 'package:mymemo_with_flutterfire/components/memo-rendered.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';
import 'package:mymemo_with_flutterfire/providers/auth.dart';
import 'package:mymemo_with_flutterfire/providers/memos.dart';
import 'package:mymemo_with_flutterfire/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

class MemoDetailPage extends StatefulWidget {
  final String id;
  const MemoDetailPage({Key? key, required this.id}) : super(key: key);
  static const routeName = '/detail';

  @override
  State<MemoDetailPage> createState() => _MemoDetailPageState();
}

class _MemoDetailPageState extends State<MemoDetailPage>
    with SingleTickerProviderStateMixin {
  bool _editing = false;
  bool _loading = true;
  Memo? memo;
  @override
  void initState() {
    // use context in initState
    () async {
      await Future.delayed(Duration.zero);
      if (widget.id != 'new') {
        final memoFetched = await Provider.of<Memos>(context, listen: false)
            .getItemById(widget.id);
        setState(() {
          memo = memoFetched;
          _loading = false;
        });
      } else {
        final auth = Provider.of<Auth>(context, listen: false);
        if (auth.signedIn) {
          setState(() {
            memo = Memo(title: '', content: '', userId: auth.userId);
            _editing = true;
            _loading = false;
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
              title: Text(_loading ? 'Loading...' : memo?.title ?? 'Not found'),
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
            body: _loading
                ? const Loading()
                : memo == null
                    ? const Center(
                        child: Text('Memo not found.'),
                      )
                    : _editing
                        ? MemoEditor(memo: memo!)
                        : MemoRendered(content: memo!.content),
            floatingActionButton: Visibility(
              visible:
                  memo != null && auth.signedIn && memo!.userId == auth.userId,
              child: Container(
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
                      final isNewMemo = memo!.id == null;
                      try {
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
                      if (isNewMemo) {
                        GoRouter.of(context).go('/memos/${memo!.id}');
                      }
                    } else {
                      setState(() {
                        _editing = true;
                      });
                    }
                  },
                  child: _FadeThroughTransitionSwitcher(
                      fillColor: Colors.transparent,
                      child: _editing
                          ? const Icon(
                              Icons.save,
                              key: ValueKey('saveBtn'),
                            )
                          : const Icon(Icons.edit)),
                ),
              ),
            )));
  }
}

class _FadeThroughTransitionSwitcher extends StatelessWidget {
  const _FadeThroughTransitionSwitcher({
    required this.fillColor,
    required this.child,
  });

  final Widget child;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (child, animation, secondaryAnimation) {
        return FadeThroughTransition(
          fillColor: fillColor,
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
        );
      },
      child: child,
    );
  }
}
