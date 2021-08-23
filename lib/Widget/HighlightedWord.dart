// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace, overridden_fields

import 'package:flutter/cupertino.dart';
import 'package:highlight_text/highlight_text.dart';

class RPMHighlightedWord extends HighlightedWord {
  final TextStyle textStyle;
  final VoidCallback onTap;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final String? tooltip;

  RPMHighlightedWord(
      {required this.onTap,
      required this.textStyle,
      this.decoration,
      this.padding,
      this.tooltip})
      : super(
            onTap: onTap,
            textStyle: textStyle,
            decoration: decoration,
            padding: padding);
}
