// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rpmtranslator/API/APIs.dart';
import 'package:rpmtranslator/API/CrowdinAPI.dart';
import 'package:rpmtranslator/API/RPMTWData.dart';
import 'package:rpmtranslator/Account/Account.dart';
import 'package:rpmtranslator/Screen/Files.dart';
import 'package:rpmtranslator/Utility/utility.dart';
import 'package:rpmtranslator/Widget/AccountNone.dart';

import '../main.dart';

class ModsScreen_ extends State<ModsScreen> {
  final TextEditingController SearchController = TextEditingController();
  final ScrollController ModScrollController = ScrollController();
  final PageController ModPageController = PageController(initialPage: 0);
  final List<String> VersionItems = RPMTWDataHandler.VersionItems;
  String VersionItem = "1.17";
  int ModListLength = 0;

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
        title: Text("模組翻譯頁面"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: "返回",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => App()),
            );
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
                    hintText: "請輸入模組ID",
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
                    ModPageController.animateToPage(0,
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
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "遊戲版本",
                      style: title_,
                    ),
                    DropdownButton<String>(
                      value: VersionItem,
                      style: TextStyle(color: Colors.white),
                      onChanged: (String? newValue) {
                        VersionItem = newValue.toString();
                        ModPageController.animateToPage(0,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300));
                        setState(() {});
                      },
                      items: VersionItems.map<DropdownMenuItem<String>>(
                          (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            textAlign: TextAlign.center,
                            style: title_,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.25,
                child: FutureBuilder(
                    future: RPMTWDataHandler.getCurseForgeIndex(
                        double.parse(VersionItem)),
                    builder: (context, AsyncSnapshot<Map> CurseIndexSnapshot) {
                      if (CurseIndexSnapshot.hasData) {
                        Map CurseIndex = CurseIndexSnapshot.data!;
                        return PageView.builder(
                            controller: ModPageController,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, int Page) {
                              return FutureBuilder(
                                  future: CrowdinAPI.getModsByVersion(
                                      Account.getToken(),
                                      VersionItem,
                                      SearchController.text,
                                      Page),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          controller: ModScrollController,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, int Index) {
                                            ModListLength =
                                                snapshot.data.length;
                                            Map data =
                                                snapshot.data[Index]['data'];
                                            String DirName =
                                                data['name'].toString();
                                            int CurseID = int.parse(
                                                CurseIndex[DirName] ?? "0");
                                            return FutureBuilder(
                                                future: RPMTWDataHandler
                                                    .getCurseForgeAddonInfo(
                                                        CurseID),
                                                builder: (context,
                                                    AsyncSnapshot<Map>
                                                        CurseAddonSnapshot) {
                                                  if (CurseAddonSnapshot
                                                      .hasData) {
                                                    bool IsCurseMod =
                                                        CurseAddonSnapshot
                                                                    .data !=
                                                                {} &&
                                                            CurseIndex
                                                                .containsKey(
                                                                    DirName);
                                                    return ListTile(
                                                        leading: SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: Builder(
                                                                builder:
                                                                    (context) {
                                                              if (IsCurseMod) {
                                                                Map?
                                                                    CurseAddonInfo =
                                                                    CurseAddonSnapshot
                                                                        .data;
                                                                if (CurseAddonInfo!
                                                                        .containsKey(
                                                                            'attachments') &&
                                                                    CurseAddonInfo[
                                                                            'attachments']
                                                                        .isNotEmpty) {
                                                                  return Image.network(
                                                                      CurseAddonInfo['attachments']
                                                                              [
                                                                              0]
                                                                          [
                                                                          'thumbnailUrl'],
                                                                      fit: BoxFit
                                                                          .fill);
                                                                } else {
                                                                  return Icon(
                                                                      Icons
                                                                          .image,
                                                                      size: 50);
                                                                }
                                                              } else {
                                                                return Icon(
                                                                    Icons.image,
                                                                    size: 50);
                                                              }
                                                            }),
                                                          ),
                                                        ),
                                                        title: Text(DirName),
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) =>
                                                                  FilesScreen(
                                                                      DirID: data[
                                                                          'id']));
                                                        },
                                                        trailing: SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child: Builder(
                                                              builder:
                                                                  (context) {
                                                            if (IsCurseMod) {
                                                              Map?
                                                                  CurseAddonInfo =
                                                                  CurseAddonSnapshot
                                                                      .data;
                                                              return Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        utility.OpenUrl(
                                                                            CurseAddonInfo!['websiteUrl']);
                                                                      },
                                                                      icon: Icon(
                                                                          Icons
                                                                              .open_in_browser),
                                                                      tooltip:
                                                                          "在 CurseForge 檢視此模組",
                                                                    )
                                                                  ]);
                                                            } else {
                                                              return Container();
                                                            }
                                                          }),
                                                        ));
                                                  } else {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  }
                                                });
                                          });
                                    } else if (snapshot.hasData &&
                                        snapshot.data == null) {
                                      return AccountNone();
                                    } else if (snapshot.hasError) {
                                      return Text(snapshot.error.toString());
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                  });
                            });
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    })),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    tooltip: "上一頁",
                    onPressed: () {
                      ModPageController.animateToPage(
                          ModPageController.page!.toInt() - 1,
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
                      if (ModListLength < 20) return;
                      ModPageController.animateToPage(
                          ModPageController.page!.toInt() + 1,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300));
                    },
                    icon: Icon(Icons.navigate_next))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ModsScreen extends StatefulWidget {
  @override
  ModsScreen_ createState() => ModsScreen_();
}
