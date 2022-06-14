import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircularProgressIndicator(
          color: Colors.white,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Loading',
          style: TextStyle(fontSize: 26),
        )
      ],
    ));
  }
}
