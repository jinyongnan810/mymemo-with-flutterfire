import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/notifiers/memos_notifier.dart';

final memosNotifierProvider = StateNotifierProvider<MemosNotifier, MemosState>(
  (_) => MemosNotifier(),
);
