// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace, no_logic_in_create_state

import 'dart:io';

import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rpmtranslator/API/CrowdinAPI.dart';
import 'package:rpmtranslator/Account/Account.dart';
import 'package:rpmtranslator/Widget/OkClose.dart';

class DownloadFile extends StatefulWidget {
  final int FileID;
  const DownloadFile({
    required this.FileID,
    Key? key,
  }) : super(key: key);

  @override
  State<DownloadFile> createState() => _DownloadFileState(FileID: FileID);
}

class _DownloadFileState extends State<DownloadFile> {
  final int FileID;
  _DownloadFileState({
    required this.FileID,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("下載檔案"),
        content: Text("請選擇檔案要儲存的位置"),
        actions: [
          TextButton(
              onPressed: () async {
                final String? path =
                    await FileSelectorPlatform.instance.getSavePath();
                if (path != null) {
                  Navigator.pop(context);
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return FutureBuilder(
                            future: CrowdinAPI.downloadFile(
                              Account.getToken(),
                              FileID,
                              File(path),
                            ),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData && snapshot.data) {
                                return AlertDialog(
                                  title: Text("下載檔案完成"),
                                  actions: [OkClose()],
                                );
                              } else {
                                return AlertDialog(
                                  title: Text("正在從 Crowdin 伺服器下載檔案中..."),
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
