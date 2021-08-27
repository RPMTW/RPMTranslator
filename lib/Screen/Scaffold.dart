// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RPMScaffold extends StatelessWidget {
  final Widget child;
  const RPMScaffold({required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: "返回",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: child);
  }
}
