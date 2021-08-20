// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rpmtranslator/Account/Account.dart';

import 'Screen/Account.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RPMTranslator - RPMTW 模組專屬翻譯器',
      theme: ThemeData(brightness: Brightness.dark, fontFamily: 'font'),
      home: const HomePage(title: 'RPMTranslator - RPMTW 模組專屬翻譯器'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    if (!Account.AccountFile.existsSync()) {
      //如果不存在帳號檔案就建立一個
      Account.AccountFile
        ..createSync(recursive: true)
        ..writeAsStringSync(json.encode({}));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true, actions: [
        IconButton(
          icon: Icon(Icons.manage_accounts),
          onPressed: () {
            showDialog(context: context, builder: (context) => AccountScreen());
          },
          tooltip: "登入帳號",
        ),
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
