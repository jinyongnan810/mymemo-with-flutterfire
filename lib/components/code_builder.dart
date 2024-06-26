import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/ocean.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:markdown/markdown.dart' as md;
import 'package:mymemo_with_flutterfire/shared/show_snackbar.dart';

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

    final isBlock = element.textContent.contains('\n');

    return SizedBox(
      width: isBlock ? double.infinity : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isBlock ? 12.0 : 4.0),
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
            theme: oceanTheme,

            // Specify padding
            padding: EdgeInsets.symmetric(
              vertical: isBlock ? 8 : 1,
              horizontal: isBlock ? 12 : 4,
            ),

            // Specify text style
            textStyle: GoogleFonts.caveat().copyWith(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
