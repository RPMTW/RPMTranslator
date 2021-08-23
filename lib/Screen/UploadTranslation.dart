// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace, no_logic_in_create_state

import 'dart:io';

import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:rpmtranslator/API/CrowdinAPI.dart';
import 'package:rpmtranslator/Account/Account.dart';
import 'package:rpmtranslator/Widget/OkClose.dart';

class UploadTranslation extends StatefulWidget {
  final int FileID;
  final String FileName;
  const UploadTranslation({
    required this.FileID,
    required this.FileName,
    Key? key,
  }) : super(key: key);

  @override
  State<UploadTranslation> createState() =>
      _UploadTranslationState(FileID: FileID, FileName: FileName);
}

class _UploadTranslationState extends State<UploadTranslation> {
  final int FileID;
  final String FileName;
  _UploadTranslationState({
    required this.FileID,
    required this.FileName,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("上傳翻譯"),
        content: Text("請選擇要上傳的檔案"),
        actions: [
          TextButton(
              onPressed: () async {
                final XFile? file = await FileSelectorPlatform.instance
                    .openFile(acceptedTypeGroups: [
                  XTypeGroup(
                      label: "翻譯檔案", extensions: [path.extension(FileName)])
                ]);
                if (file != null) {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return FutureBuilder(
                            future: CrowdinAPI.updateTranslation(
                                Account.getToken(),
                                File(file.path),
                                FileID,
                                FileName),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data == true) {
                                  return AlertDialog(
                                    title: Text("上傳成功"),
                                    actions: [OkClose()],
                                  );
                                } else {
                                  return AlertDialog(
                                    title: Text("上傳失敗"),
                                    actions: [OkClose()],
                                  );
                                }
                              } else {
                                return AlertDialog(
                                  title: Text("上傳檔案至 Crowdin 伺服器中..."),
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                );
                              }
                            });
                      });
                } else {
                  return;
                }
              },
              child: Text("選擇檔案"))
        ]);
  }
}
