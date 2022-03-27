import 'package:flutter/material.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';

class MemoItem extends StatelessWidget {
  final Memo memo;
  const MemoItem(this.memo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(memo.title),
    );
  }
}
