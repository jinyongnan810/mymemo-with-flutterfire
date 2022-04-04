import 'package:flutter/material.dart';
import 'package:mymemo_with_flutterfire/models/memo.dart';
import 'package:mymemo_with_flutterfire/pages/memo-detail.dart';

class MemoItem extends StatelessWidget {
  final Memo memo;
  const MemoItem(this.memo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(10),
      onTap: () => Navigator.of(context)
          .pushNamed(MemoDetailPage.routeName, arguments: memo.id),
      child: Text(memo.title),
    );
  }
}
