import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mymemo_with_flutterfire/components/loading/loading_screen.dart';
import 'package:mymemo_with_flutterfire/firebase_options.dart';
import 'package:mymemo_with_flutterfire/pages/memo_detail.dart';
import 'package:mymemo_with_flutterfire/pages/memo_list.dart';
import 'package:mymemo_with_flutterfire/providers/is_loading_provider.dart';
import 'package:mymemo_with_flutterfire/shared/show_snackbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  window.document.onContextMenu.listen((evt) => evt.preventDefault());
  // timeDilation = 5.0;
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final _router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return Consumer(builder: (ctx, ref, child) {
          ref.listen<String?>(isLoadingProvider, (previous, next) {
            if (next != null) {
              LoadingScreen.instance().show(context: ctx, text: next);
            } else if (next == null) {
              LoadingScreen.instance().hide();
            }
          });

          return const MemoListPage();
        });
      },
      routes: [
        GoRoute(
          path: 'memos/:id',
          builder: (context, state) {
            final id = state.params['id']!;

            return MemoDetailPage(id: id);
          },
        ),
      ],
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // title: "Kin's Page",
      // gets null, need use onGenerateTitle
      // title: K.of(context)!.appTitle,
      onGenerateTitle: (ctx) => K.of(ctx)!.appTitle,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData.dark(),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      // after changing to .router, need change navigatorKey to scaffoldMessengerKey
      // navigatorKey: NavigationService.navigatorKey,
      localizationsDelegates: const [
        K.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ja', ''),
      ],
    );
  }
}
