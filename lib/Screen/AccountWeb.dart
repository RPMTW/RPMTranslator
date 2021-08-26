// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element
import 'package:flutter/material.dart';
import 'package:rpmtranslator/Account/Account.dart';
import 'package:rpmtranslator/Account/CrowdinAuth.dart';
import 'package:rpmtranslator/Utility/utility.dart';

import '../main.dart';

class AccountWebScreen_ extends State<AccountWebScreen> {
  bool _obscureText = true;

  TextEditingController TokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  var title_ = TextStyle(
    fontSize: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (Account.has() && !Account.expired()) {
        //已經有帳號了，並且該帳號沒有過期
        return AlertDialog(
          title: Text("您已經登入過帳號了"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("關閉此頁面")),
            TextButton(
                onPressed: () {
                  Account.logout();
                  Navigator.pop(context);
                },
                child: Text("登出帳號"))
          ],
        );
      } else {
        return AlertDialog(
          title: Text("登入 Crowdin 帳號", textAlign: TextAlign.center),
          content: Text("點擊下方的登入按鈕將會開啟 Crowdin 的授權網頁，請在該網頁上登入帳號"),
          actions: [
            IconButton(
              icon: Icon(Icons.login),
              onPressed: () {
                utility.OpenUrl(
                    'https://accounts.crowdin.com/oauth/authorize?client_id=8HpxK2jINouRXTrVq6gf&redirect_uri=https://rear-end.a102009102009.repl.co/crowdin/oauth/auth/web&response_type=code&scope=project');
              },
              tooltip: "登入",
            ),
          ],
        );
      }
    });
  }
}

class AccountWebScreen extends StatefulWidget {
  @override
  AccountWebScreen_ createState() => AccountWebScreen_();
}
