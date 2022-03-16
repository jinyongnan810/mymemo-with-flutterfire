import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  await Memo(userId: 'user-id', title: 'test1', content: 'test1content').save();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kin's Page"),
      ),
      body: const Center(child: Text('empty')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {},
      ),
    );
  }
}
