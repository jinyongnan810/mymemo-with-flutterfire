// ignore_for_file: use_build_context_synchronously

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/components/memo_editor.dart';
import 'package:mymemo_with_flutterfire/components/memo_rendered.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';
import 'package:mymemo_with_flutterfire/providers/memo_provider.dart';
import 'package:mymemo_with_flutterfire/providers/memos_notifier_provider.dart';
import 'package:mymemo_with_flutterfire/providers/user_id_provider.dart';
import 'package:mymemo_with_flutterfire/shared/loading.dart';

class MemoDetailPage extends HookConsumerWidget {
  final String id;
  const MemoDetailPage({super.key, required this.id});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);

    final isNewMemo = id == "new";
    if (isNewMemo) {
      if (userId == null) {
        return const MemoDetail(
          memo: null,
          isMine: false,
          onAddMemo: null,
          onSaveMemo: null,
        );
      }
      final memo = Memo(userId: userId, title: '', content: '');

      return MemoDetail(
        memo: memo,
        isMine: true,
        onAddMemo: (memo) =>
            ref.read(memosNotifierProvider.notifier).addItem(memo),
        onSaveMemo: (memo) =>
            ref.read(memosNotifierProvider.notifier).updateItem(memo),
      );
    }
    final memoFuture = ref.watch(memoProvider(id));

    return memoFuture.when(
      data: (memo) => MemoDetail(
        memo: memo,
        isMine: userId != null && memo?.userId == userId,
        onAddMemo: (memo) =>
            ref.read(memosNotifierProvider.notifier).addItem(memo),
        onSaveMemo: (memo) =>
            ref.read(memosNotifierProvider.notifier).updateItem(memo),
      ),
      error: (_, __) => const Center(
        child: Text('Error finding memo'),
      ),
      loading: () => const Loading(),
    );
  }
}

class MemoDetail extends HookWidget {
  final Memo? memo;
  final bool isMine;
  final void Function(Memo)? onAddMemo;
  final void Function(Memo)? onSaveMemo;
  const MemoDetail({
    super.key,
    required this.memo,
    required this.isMine,
    required this.onAddMemo,
    required this.onSaveMemo,
  });

  @override
  Widget build(BuildContext context) {
    final editing = useState(false);
    useEffect(
      () {
        if (memo != null && memo!.id == null) {
          editing.value = true;
        }

        return null;
      },
      [],
    );

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
            : editing.value
                ? MemoEditor(memo: memo!)
                : MemoRendered(content: memo!.content),
        floatingActionButton: Visibility(
          visible: memo != null && isMine,
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
              shape: const CircleBorder(),
              onPressed: () async {
                if (editing.value) {
                  final isNewMemo = memo!.id == null;
                  try {
                    await memo!.save();
                    if (isNewMemo) {
                      onAddMemo?.call(memo!);
                    } else {
                      onSaveMemo?.call(memo!);
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
                  editing.value = false;
                  if (isNewMemo) {
                    context.go('/memos/${memo!.id}');
                  }
                } else {
                  editing.value = true;
                }
              },
              child: _FadeThroughTransitionSwitcher(
                fillColor: Colors.transparent,
                child: editing.value
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
