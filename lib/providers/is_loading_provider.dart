import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/providers/auth_notifier_provider.dart';
import 'package:mymemo_with_flutterfire/providers/memos_notifier_provider.dart';
import 'package:mymemo_with_flutterfire/typedef.dart';

final isLoadingProvider = Provider<IsLoading>((ref) {
  final authIsLoading = ref.watch(authNotifierProvider);
  final memosState = ref.watch(memosNotifierProvider);
  final isLoading = [
    authIsLoading,
    memosState.isLoading,
  ].any((e) => e);

  return isLoading;
});
