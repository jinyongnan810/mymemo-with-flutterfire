import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mymemo_with_flutterfire/components/memo-list.dart';
import 'package:mymemo_with_flutterfire/pages/memo-detail.dart';
import 'package:mymemo_with_flutterfire/pages/memo-list.dart';
import 'package:mymemo_with_flutterfire/providers/auth.dart';
import 'package:mymemo_with_flutterfire/providers/memos.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

import 'package:mymemo_with_flutterfire/models/memo.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: dotenv.env['API_KEY']!,
    authDomain: dotenv.env['AUTH_DOMAIN']!,
    projectId: dotenv.env['PROJECT_ID']!,
    messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
    appId: dotenv.env['APP_ID']!,
  ));

  // for (int i = 0; i < 50; i++) {
  //   final memo =
  //       Memo(userId: 'user-id-$i', title: 'test$i', content: 'content$i');
  //   await memo.save();
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Memos()),
          ChangeNotifierProvider(create: (ctx) => Auth())
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
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
