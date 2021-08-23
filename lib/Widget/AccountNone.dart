// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rpmtranslator/Account/Account.dart';
import 'package:rpmtranslator/Account/CrowdinAuth.dart';
import 'package:rpmtranslator/Utility/utility.dart';
import 'package:rpmtranslator/Widget/OkClose.dart';

class AccountNone extends StatelessWidget {
  const AccountNone({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Account.has() && Account.expired()) {
      return FutureBuilder(
          future: CrowdinAuthHandler.RefreshToken(Account.getRefreshToken()),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return AlertDialog(
                  title: Text("提示訊息"),
                  content: Text("更新登入憑證成功"),
                  actions: [OkClose()],
                );
              } else {
                return AlertDialog(
                  title: Text("錯誤訊息"),
                  content: Text("更新登入憑證失敗，請手動重新登入"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          utility.IsWebAccount(context);
                        },
                        child: Text("確定"))
                  ],
                );
              }
            } else {
              return AlertDialog(
                title: Text("錯誤訊息"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("偵測到您的 Crowdin 登入憑證已過期，正在嘗試更新登入憑證..."),
                    SizedBox(height: 12),
                    CircularProgressIndicator()
                  ],
                ),
              );
            }
          });
    } else {
      return AlertDialog(
        title: Text("提示訊息"),
        content: Text("請先登入帳號再執行此步驟"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                utility.IsWebAccount(context);
              },
              child: Text("確定"))
        ],
      );
    }
  }
}
