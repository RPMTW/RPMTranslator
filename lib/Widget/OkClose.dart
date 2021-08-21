// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OkClose extends StatelessWidget {
  const OkClose({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("確定"));
  }
}
