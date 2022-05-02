import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mymemo_with_flutterfire/pages/memo-detail.dart';
import 'package:mymemo_with_flutterfire/pages/memo-list.dart';
import 'package:mymemo_with_flutterfire/providers/auth.dart';
import 'package:mymemo_with_flutterfire/providers/memos.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: "env");
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: dotenv.env['API_KEY'] ?? '',
    authDomain: dotenv.env['AUTH_DOMAIN'] ?? '',
    projectId: dotenv.env['PROJECT_ID'] ?? '',
    messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? '',
    appId: dotenv.env['APP_ID'] ?? '',
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Auth();
    auth.watch();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Memos()),
          ChangeNotifierProvider(create: (ctx) => auth)
        ],
        child: MaterialApp(
          title: "Kin's Page",
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          routes: {
            '/': (ctx) => const MemoListPage(),
            '/detail': (ctx) => const MemoDetailPage()
          },
          debugShowCheckedModeBanner: false,
        ));
  }
}
