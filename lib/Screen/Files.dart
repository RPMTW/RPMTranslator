// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace, no_logic_in_create_state
import 'package:flutter/material.dart';
import 'package:rpmtranslator/API/CrowdinAPI.dart';
import 'package:rpmtranslator/Account/Account.dart';
import 'package:rpmtranslator/Widget/AccountNone.dart';

import 'Translate.dart';
import 'UploadTranslation.dart';

class FilesScreen_ extends State<FilesScreen> {
  final TextEditingController SearchController = TextEditingController();
  final ScrollController FilesScrollController = ScrollController();
  final PageController FilesPageController = PageController(initialPage: 0);
  int FilesListLength = 0;

  final int DirID;

  FilesScreen_({required this.DirID});

  @override
  void initState() {
    super.initState();
  }

  var title_ = TextStyle(
    fontSize: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("檔案選擇頁面"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: "返回",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  "搜尋模組",
                  style: title_,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: TextField(
                  textAlign: TextAlign.center,
                  controller: SearchController,
                  decoration: InputDecoration(
                    hintText: "請輸入檔案名稱",
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlue, width: 5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlue, width: 3.0),
                    ),
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                )),
                SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  style: new ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurpleAccent)),
                  onPressed: () {
                    FilesPageController.animateToPage(0,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300));
                    setState(() {});
                  },
                  child: Text(
                    "搜尋",
                    style: title_,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.3,
              child: PageView.builder(
                  controller: FilesPageController,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, int Page) {
                    return FutureBuilder(
                        future: CrowdinAPI.getFilesByDir(Account.getToken(),
                            DirID, SearchController.text, Page),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return ListView.builder(
                                shrinkWrap: true,
                                controller: FilesScrollController,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, int Index) {
                                  FilesListLength = snapshot.data.length;
                                  Map data = snapshot.data[Index]['data'];
                                  String FileName = data['name'].toString();
                                  FileName == "zh_tw.json"
                                      ? FileName = "主要語系檔案"
                                      : FileName;
                                  return ListTile(
                                    title: Text(FileName,
                                        textAlign: TextAlign.center),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => TranslateScreen(
                                              FileID: data['id'],
                                              FileName: FileName));
                                    },
                                    trailing: PopupMenuButton(
                                        tooltip: "顯示更多",
                                        itemBuilder: (context) => [
                                              PopupMenuItem(
                                                child: Text("翻譯"),
                                                value: 1,
                                              ),
                                              PopupMenuItem(
                                                child: Text("上傳翻譯"),
                                                value: 2,
                                              ),
                                              PopupMenuItem(
                                                child: Text("下載檔案"),
                                                value: 3,
                                              )
                                            ],
                                        onSelected: (int Index) {
                                          switch (Index) {
                                            case 1:
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      TranslateScreen(
                                                          FileID: data['id'],
                                                          FileName: FileName));
                                              break;
                                            case 2:
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      UploadTranslation(
                                                          FileID: data['id'],
                                                          FileName:
                                                              data['name']));
                                              break;
                                            default:
                                              break;
                                          }
                                        }),
                                  );
                                });
                          } else if (snapshot.hasData &&
                              snapshot.data == null) {
                            return AccountNone();
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        });
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    tooltip: "上一頁",
                    onPressed: () {
                      FilesPageController.animateToPage(
                          FilesPageController.page!.toInt() - 1,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300));
                    },
                    icon: Icon(Icons.navigate_before)),
                SizedBox(
                  width: 20,
                ),
                IconButton(
                    tooltip: "下一頁",
                    onPressed: () {
                      if (FilesListLength < 20) return;
                      FilesPageController.animateToPage(
                          FilesPageController.page!.toInt() + 1,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300));
                    },
                    icon: Icon(Icons.navigate_next))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FilesScreen extends StatefulWidget {
  final int DirID;

  const FilesScreen({required this.DirID});

  @override
  FilesScreen_ createState() => FilesScreen_(DirID: DirID);
}
