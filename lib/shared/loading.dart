import 'package:flutter/material.dart';
import 'package:mymemo_with_flutterfire/components/lottie_animation_view.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: LottieAnimationView.loading());
    // return Center(
    //     child: Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     LottieAnimationView.loading(),
    //     const SizedBox(
    //       height: 20,
    //     ),
    //     const Text(
    //       'Loading',
    //       style: TextStyle(fontSize: 26),
    //     )
    //   ],
    // ));
  }
}
