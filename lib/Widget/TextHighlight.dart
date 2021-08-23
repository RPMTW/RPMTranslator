// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace, overridden_fields

import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';

import 'HighlightedWord.dart';

class RPMTextHighlight extends TextHighlight {
  final String text;
  final LinkedHashMap<String, RPMHighlightedWord> words;
  final TextStyle textStyle;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final bool enableCaseSensitive;

  RPMTextHighlight({
    required this.text,
    required this.words,
    this.textStyle = const TextStyle(
      fontSize: 25.0,
      color: Colors.white,
    ),
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.enableCaseSensitive = false,
  }) : super(
            text: text,
            words: words,
            textStyle: textStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            softWrap: softWrap,
            overflow: overflow,
            textScaleFactor: textScaleFactor,
            maxLines: maxLines,
            locale: locale,
            strutStyle: strutStyle);

  @override
  Widget build(BuildContext context) {
    List<String> _textWords = _bind();

    return RichText(
      text: _buildSpan(_textWords),
      locale: locale,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      textScaleFactor: textScaleFactor,
    );
  }

  List<String> _bind() {
    String bindedText = text;
    for (String word in words.keys) {
      if (enableCaseSensitive) {
        bindedText = bindedText.replaceAll(
            word, '<highlight>${words.keys.toList().indexOf(word)}<highlight>');
      } else {
        int strIndex = bindedText.toLowerCase().indexOf(word.toLowerCase());
        if (strIndex > 0) {
          bindedText = bindedText.replaceRange(strIndex, strIndex + word.length,
              '<highlight>${words.keys.toList().indexOf(word)}<highlight>');
        }
      }
    }

    List<String> splitedTexts = bindedText.split("<highlight>");
    splitedTexts.removeWhere((s) => s.isEmpty);

    return splitedTexts;
  }

  TextSpan _buildSpan(List<String> bindedWords) {
    if (bindedWords.isEmpty) return TextSpan();

    String nextToDisplay = bindedWords.first;
    bindedWords.removeAt(0);

    int? index = int.tryParse(nextToDisplay);

    if (index != null) {
      String currentWord = words.keys.toList()[index];
      return TextSpan(
        children: [
          WidgetSpan(
            child: Tooltip(
              message: words[currentWord]!.tooltip ?? "",
              child: GestureDetector(
                onTap: words[currentWord]!.onTap,
                child: Container(
                  padding: words[currentWord]!.padding,
                  decoration: words[currentWord]!.decoration,
                  child: Text(
                    currentWord,
                    style: words[currentWord]!.textStyle,
                  ),
                ),
              ),
            ),
          ),
          _buildSpan(bindedWords),
        ],
      );
    }

    return TextSpan(
      text: nextToDisplay,
      style: textStyle,
      children: [
        _buildSpan(bindedWords),
      ],
    );
  }
}
