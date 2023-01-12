import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mymemo_with_flutterfire/components/loading/loading_screen_controller.dart';
import 'package:mymemo_with_flutterfire/components/lottie_animation_view.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? controller;
  void show({
    required BuildContext context,
    required String text,
  }) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = _showOverlay(
        context: context,
        text: text,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  // ignore: long-method
  LoadingScreenController _showOverlay({
    required BuildContext context,
    required String text,
  }) {
    // create a stream of text
    final textStream = StreamController<String>();
    textStream.add(text);

    // get available size
    final renderBox = context.findRenderObject() as RenderBox;
    final availableSize = renderBox.size;

    // display the overlay
    final overlay = OverlayEntry(
      builder: (ctx) => Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: availableSize.width * 0.8,
              minWidth: availableSize.width * 0.5,
              maxHeight: availableSize.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LottieAnimationView.loading(),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<String>(
                      stream: textStream.stream,
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.requireData,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          );
                        }

                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final state = Overlay.of(context);
    state?.insert(overlay);

    return LoadingScreenController(
      close: () {
        textStream.close();
        overlay.remove();

        return true;
      },
      update: (text) {
        textStream.add(text);

        return true;
      },
    );
  }
}
