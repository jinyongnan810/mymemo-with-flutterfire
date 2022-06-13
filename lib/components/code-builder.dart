import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_highlight/themes/ocean.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:google_fonts/google_fonts.dart';
import 'package:mymemo_with_flutterfire/navigation-service.dart';
import 'package:mymemo_with_flutterfire/shared/show-snackbar.dart';

// from https://github.com/git-touch/highlight.dart
// from https://stackoverflow.com/a/70733069
class CodeBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }
    return SizedBox(
        width: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .size
            .width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: element.textContent));
              showSnackBar('Code copied.');
            },
            child: HighlightView(
              // The original code to be highlighted
              element.textContent,

              // Specify language
              // It is recommended to give it a value for performance
              language: language,

              // Specify highlight theme
              // All available themes are listed in `themes` folder
              theme: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                          .platformBrightness ==
                      Brightness.light
                  ? oceanTheme
                  : atomOneLightTheme,

              // Specify padding
              padding: const EdgeInsets.all(8),

              // Specify text style
              textStyle: GoogleFonts.robotoMono(),
            ),
          ),
        ));
  }
}
