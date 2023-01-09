import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';
import 'package:mymemo_with_flutterfire/providers/memos_notifier_provider.dart';

final memoProvider =
    FutureProvider.autoDispose.family<Memo?, String>((ref, id) {
  final futureMemo = ref.read(memosNotifierProvider.notifier).getItemById(id);

  return futureMemo;
});
