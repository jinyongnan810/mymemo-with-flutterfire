import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/notifiers/auth_notifier.dart';
import 'package:mymemo_with_flutterfire/typedef.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, IsLoading>(
  (_) => AuthNotifier(),
);
