// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rpmtranslator/API/APIs.dart';
import 'package:rpmtranslator/Account/Account.dart';
import 'package:rpmtranslator/Widget/AccountNone.dart';
import 'package:rpmtranslator/Widget/OkClose.dart';
import 'package:url_strategy/url_strategy.dart';
import 'Screen/Progress.dart';
import 'Screen/Mods.dart';
import 'Screen/UnknownScreen.dart';
import 'Utility/utility.dart';

extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}

void main() {
  setPathUrlStrategy();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RPMTranslator - RPMTW 模組專屬翻譯器',
      theme: ThemeData(brightness: Brightness.dark, fontFamily: 'font'),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        // Handle '/'
        if (settings.name == '/') {
          return MaterialPageRoute(
              builder: (context) =>
                  HomePage(title: 'RPMTranslator - RPMTW 模組專屬翻譯器'));
        }

        // Handle '?auth-code=${code}'
        var uri = Uri.parse(settings.name!);
        if (uri.queryParameters.containsKey('auth-code')) {
          var AuthCode = uri.queryParameters['auth-code'];
          print(AuthCode);
          if (AuthCode == "error") {
            return DialogRoute(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("提示資訊"),
                      content:
                          Text("登入帳號失敗，請嘗試重新登入，如果仍然失敗，請前往我們的 Discord 伺服器詢問"),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.manage_accounts),
                          onPressed: () {
                            utility.IsWebAccount(context);
                          },
                          tooltip: "重新登入帳號",
                        ),
                      ],
                    ));
          } else if (AuthCode == "success") {
            return DialogRoute(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("提示資訊"),
                      content: Text("登入帳號成功"),
                      actions: [OkClose()],
                    ));
          }
        }

        return MaterialPageRoute(builder: (context) => UnknownScreen());
      },
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
    if (!kIsWeb) {
      //如果不是網站才使用檔案儲存
      if (!Account.AccountFile.existsSync()) {
        //如果不存在帳號檔案就建立一個
        Account.AccountFile
          ..createSync(recursive: true)
          ..writeAsStringSync(json.encode({}));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () async {
                    await utility.OpenUrl(HomePageUrl);
                  },
                  tooltip: "官方網站"),
              Flexible(
                child: Center(
                  child: Text(widget.title),
                ),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.manage_accounts),
              onPressed: () {
                utility.IsWebAccount(context);
              },
              tooltip: "登入帳號",
            ),
            Builder(builder: (context) {
              if (kIsWeb) {
                return IconButton(
                  icon: Icon(Icons.desktop_windows),
                  onPressed: () {
                    utility.OpenUrl(
                        "https://github.com/RPMTW/RPMTranslator/releases");
                  },
                  tooltip: "下載桌面版",
                );
              } else {
                return Container();
              }
            })
          ]),
      body: Center(
        child: Transform.scale(
          scale: 2.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProgressScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.donut_large,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "查看翻譯進度",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / 130,
              ),
              TextButton(
                onPressed: () {
                  if (Account.has() && !Account.expired()) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ModsScreen()));
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AccountNone();
                        });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.translate,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("翻譯模組",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
