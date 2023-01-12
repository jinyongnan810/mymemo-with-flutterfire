import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/providers/auth_notifier_provider.dart';
import 'package:mymemo_with_flutterfire/providers/memos_notifier_provider.dart';

final isLoadingProvider = Provider<String?>((ref) {
  final authIsLoading = ref.watch(authNotifierProvider);
  final memosState = ref.watch(memosNotifierProvider);
  if (authIsLoading) {
    return 'Authenticating...';
  }
  if (memosState.isLoading) {
    return 'Loading memos...';
  }

  return null;
});
