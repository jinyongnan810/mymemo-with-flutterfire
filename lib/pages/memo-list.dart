import 'package:flutter/material.dart';
import 'package:mymemo_with_flutterfire/components/memo-list.dart';

class MemoListPage extends StatelessWidget {
  static String routeName = '/';
  const MemoListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kin's Page"),
      ),
      body: const MemoList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {},
      ),
    );
  }
}
