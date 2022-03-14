import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  if (kIsWeb) {
    print('is web');
    final docs = await FirebaseFirestore.instance.collection('tests').get();
    docs.docs.forEach(
      (element) => print(element.data()),
    );
  } else if (Platform.isWindows) {
    print('windows desktop');
    final url = Uri.parse(
        "https://firestore.googleapis.com/v1/projects/${dotenv.env['PROJECT_ID']}/databases/(default)/documents/tests");
    final ordersRes = await http.get(url);
    final Map<String, dynamic> res = jsonDecode(ordersRes.body);
    print(res);
  } else {
    print('not windows desktop or web');
    final docs = await FirebaseFirestore.instance.collection('tests').get();
    docs.docs.forEach(
      (element) => print(element.data()),
    );
  }
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
