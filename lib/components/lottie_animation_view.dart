import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mymemo_with_flutterfire/constants/lottie_animation.dart';

class LottieAnimationView extends StatelessWidget {
  const LottieAnimationView({
    super.key,
    required this.animation,
    this.repeat = true,
    this.reverse = false,
  });

  factory LottieAnimationView.loading() =>
      const LottieAnimationView(animation: LottieAnimation.loading);

  final LottieAnimation animation;
  final bool repeat;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      animation.fullPath(),
      repeat: repeat,
      reverse: reverse,
    );
  }
}
