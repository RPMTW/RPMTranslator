// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Scaffold.dart';

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RPMScaffold(
        child: Center(
            child: Text('404 找不到此頁面!', style: TextStyle(fontSize: 100))));
  }
}
