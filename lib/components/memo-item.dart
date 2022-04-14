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
      child: Stack(
        children: [
          Center(
            child: Text(memo.title),
          ),
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete_sweep,
                  color: Colors.purple,
                )),
          )
        ],
      ),
    );
  }
}
