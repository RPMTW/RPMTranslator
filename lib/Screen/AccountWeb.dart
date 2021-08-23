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
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  decoration: InputDecoration(
                      labelText: 'Crowdin 登入權杖',
                      hintText: 'Token',
                      prefixIcon: Icon(Icons.password)),
                  controller: TokenController,
                  obscureText: _obscureText // 設定控制器
                  ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Text(_obscureText ? "顯示登入權杖" : "隱藏登入權杖")),
              IconButton(
                icon: Icon(Icons.login),
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return Builder(builder: (context) {
                          if (TokenController.text == "") {
                            return AlertDialog(
                              title:
                                  Text("登入權杖不能為空", textAlign: TextAlign.center),
                              actions: [
                                IconButton(
                                  icon: Icon(Icons.close),
                                  tooltip: "OK",
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          } else {
                            return FutureBuilder(
                                future: CrowdinAuthHandler.CheckToken(
                                    TokenController.text),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data.length > 0) {
                                    List data = snapshot.data;
                                    Account.add(TokenController.text, "",
                                        data[1]['data']['id']);
                                    return AlertDialog(
                                        title: Text("登入成功",
                                            textAlign: TextAlign.center),
                                        actions: [
                                          IconButton(
                                            icon: Icon(Icons.close),
                                            tooltip: "確定",
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          App()));
                                            },
                                          )
                                        ]);
                                  } else if ((snapshot.hasData &&
                                          snapshot.data.length == 0) ||
                                      snapshot.hasError) {
                                    return AlertDialog(
                                        title: Text("登入失敗",
                                            textAlign: TextAlign.center),
                                        content: Text(
                                            "登入權杖錯誤，請嘗試再次登入，如果仍然無效請到 RPMTW Discord 伺服器詢問。",
                                            textAlign: TextAlign.center),
                                        actions: [
                                          IconButton(
                                            icon: Icon(Icons.refresh),
                                            tooltip: "重新登入",
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AccountWebScreen());
                                            },
                                          )
                                        ]);
                                  } else {
                                    return AlertDialog(
                                      title: Text("正在偵測登入權杖是否有效，請稍後...",
                                          textAlign: TextAlign.center),
                                      content: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 12,
                                          ),
                                          CircularProgressIndicator(),
                                          SizedBox(
                                            height: 12,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                });
                          }
                        });
                      });
                },
                tooltip: "登入",
              )
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              tooltip: "關閉介面",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.help_outline),
              tooltip: "如何取得登入權杖?",
              onPressed: () {
                utility.OpenUrl(
                    'https://www.rpmtw.ga/Wiki/ModInfo#crowdin-login-token');
              },
            )
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
