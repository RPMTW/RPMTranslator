// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rpmtranslator/Screen/CrowdinOauth.dart';

class AccountNone extends StatelessWidget {
  const AccountNone({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("提示訊息"),
      content: Text("請先登入帳號再執行此步驟"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                  context: context, builder: (context) => CrowdinAuthScreen());
            },
            child: Text("確定"))
      ],
    );
  }
}
