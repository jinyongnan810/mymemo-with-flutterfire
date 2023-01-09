// ignore_for_file: use_build_context_synchronously

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/components/memo_editor.dart';
import 'package:mymemo_with_flutterfire/components/memo_rendered.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';
import 'package:mymemo_with_flutterfire/providers/memo_provider.dart';
import 'package:mymemo_with_flutterfire/providers/memos_notifier_provider.dart';
import 'package:mymemo_with_flutterfire/providers/user_id_provider.dart';
import 'package:mymemo_with_flutterfire/shared/loading.dart';

class MemoDetailPage extends StatefulHookConsumerWidget {
  final String id;
  const MemoDetailPage({Key? key, required this.id}) : super(key: key);
  static const routeName = '/detail';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MemoDetailPageState();
}

class _MemoDetailPageState extends ConsumerState<MemoDetailPage> {
  bool _editing = false;
  Memo? memo;
  @override
  Widget build(BuildContext context) {
    final futureMemo = ref.read(memoProvider(widget.id));
    final myUserId = ref.watch(userIdProvider);

    return futureMemo.when(
      data: (memo) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple, Colors.orange],
            ),
          ),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(memo?.title ?? 'Not found'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: memo == null
                ? const Center(
                    child: Text('Memo not found.'),
                  )
                : _editing
                    ? MemoEditor(memo: memo)
                    : MemoRendered(content: memo.content),
            floatingActionButton: Visibility(
              visible: memo != null && memo.userId == myUserId,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.purple, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  onPressed: () async {
                    if (_editing) {
                      final isNewMemo = memo!.id == null;
                      try {
                        await memo.save();
                        if (isNewMemo) {
                          ref
                              .read(memosNotifierProvider.notifier)
                              .addItem(memo);
                        } else {
                          ref
                              .read(memosNotifierProvider.notifier)
                              .updateItem(memo);
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error saving memo.'),
                          ),
                        );

                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Memo saved.'),
                        ),
                      );
                      setState(() {
                        _editing = false;
                      });
                      if (isNewMemo) {
                        context.go('/memos/${memo.id}');
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
                        : const Icon(Icons.edit),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      error: (_, __) => const SizedBox.shrink(),
      loading: () => const Loading(),
    );
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
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: child,
    );
  }
}
