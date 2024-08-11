import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/providers/logged_in_status_provider.dart';

class AddNewMemoButton extends ConsumerWidget {
  const AddNewMemoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(loggedInStatusProvider);

    return isLoggedIn.when(
      data: (loggedIn) => loggedIn
          ? Container(
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
                onPressed: () {
                  context.go('/memos/new');
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.add),
              ),
            )
          : const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
