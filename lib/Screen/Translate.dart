// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace, no_logic_in_create_state, curly_braces_in_flow_control_structures, unrelated_type_equality_checks
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rpmtranslator/API/CrowdinAPI.dart';
import 'package:rpmtranslator/Account/Account.dart';
import 'package:rpmtranslator/Utility/utility.dart';
import 'package:rpmtranslator/Widget/AccountNone.dart';
import 'package:split_view/split_view.dart';

class TranslateScreen_ extends State<TranslateScreen> {
  final TextEditingController SearchController = TextEditingController();
  final TextEditingController TranslateTextController = TextEditingController();
  final ScrollController TranslateScrollController = ScrollController();
  final PageController TranslatePageController = PageController(initialPage: 0);
  int TranslateListLength = 0;

  final int FileID;
  final String FileName;
  int SelectIndex = -1;
  int StringPage = 0;
  Map SelectStringInfo = {};
  late var setView2State;
  TranslateScreen_({required this.FileID, required this.FileName});

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
          title: Text("$FileName - 翻譯頁面"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: "返回",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body: SplitView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                          "搜尋字串",
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
                            hintText: "請輸入要查詢的字串",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.lightBlue, width: 5.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.lightBlue, width: 3.0),
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
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.deepPurpleAccent)),
                          onPressed: () {
                            TranslatePageController.animateToPage(0,
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
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: PageView.builder(
                          controller: TranslatePageController,
                          itemBuilder: (context, int Page) {
                            StringPage = Page;
                            return FutureBuilder(
                                future: CrowdinAPI.getSourceStringByFile(
                                    Account.getToken(),
                                    FileID,
                                    SearchController.text,
                                    Page),
                                builder: (context,
                                    AsyncSnapshot<List<dynamic>?> snapshot) {
                                  if (snapshot.hasData) {
                                    TranslateListLength = snapshot.data!.length;
                                    return StatefulBuilder(
                                        builder: (context, setModListState) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, int index) {
                                              Map StringInfo =
                                                  snapshot.data![index]['data'];
                                              String SourceString =
                                                  StringInfo['text'].toString();

                                              return ListTile(
                                                title: Text(SourceString),
                                                onTap: () {
                                                  SelectIndex = index;
                                                  SelectStringInfo = StringInfo;
                                                  setModListState(() {});
                                                  setView2State(() {});
                                                },
                                                tileColor: SelectIndex == index
                                                    ? Colors.white12
                                                    : Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                              );
                                            }),
                                      );
                                    });
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                });
                          }),
                    ),
                    StatefulBuilder(builder: (context, setChangePageState) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              tooltip: "上一頁",
                              onPressed: () async {
                                await TranslatePageController.animateToPage(
                                    TranslatePageController.page!.toInt() - 1,
                                    curve: Curves.easeOut,
                                    duration:
                                        const Duration(milliseconds: 300));
                                setChangePageState(() {});
                              },
                              icon: Icon(Icons.navigate_before)),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            (StringPage + 1).toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          IconButton(
                              tooltip: "下一頁",
                              onPressed: () async {
                                if (TranslateListLength < 20) return;
                                await TranslatePageController.animateToPage(
                                    TranslatePageController.page!.toInt() + 1,
                                    curve: Curves.easeOut,
                                    duration:
                                        const Duration(milliseconds: 300));
                                setChangePageState(() {});
                              },
                              icon: Icon(Icons.navigate_next))
                        ],
                      );
                    })
                  ],
                ),
              ),
              TranslationStringView(),
              Container(
                child: Center(child: Text("資料庫...")),
              ),
            ],
            controller: SplitViewController(
                limits: [null, WeightLimit(max: 0.7, min: 0.3)]),
            gripSize: 3,
            viewMode: SplitViewMode.Horizontal));
  }

  Builder TranslationStringView() {
    return Builder(builder: (context) {
      List TranslationStrings = [];
      return Container(
        child: StatefulBuilder(builder: (context, setView2State_) {
          setView2State = setView2State_;
          return SplitView(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Builder(builder: (context) {
                    if (SelectStringInfo != {} &&
                        SelectStringInfo.containsKey('text')) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  utility.OpenUrl(
                                      "https://crowdin.com/translate/resourcepack-mod-zhtw/all/en-zhtw?filter=basic&value=0#q=${SelectStringInfo['id']}");
                                },
                                icon: Icon(Icons.open_in_browser),
                                tooltip: "在 Crowdin 網站檢視此字串",
                              ),
                              IconButton(
                                onPressed: () {
                                  utility.OpenUrl(
                                      "https://crowdin.com/project/resourcepack-mod-zhtw/activity-stream?lang=56&translation_id=${SelectStringInfo['id']}");
                                },
                                icon: Icon(Icons.history),
                                tooltip: "在 Crowdin 網站查看此字串的變更紀錄",
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText("原文:",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 25)),
                                SizedBox(
                                  width: 10,
                                ),
                                AutoSizeText(SelectStringInfo['text'],
                                    style: TextStyle(fontSize: 25)),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText("語系鍵:",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 25)),
                                SizedBox(
                                  width: 10,
                                ),
                                AutoSizeText(
                                    SelectStringInfo['context']
                                        .toString()
                                        .split("-> ")
                                        .join(""),
                                    style: TextStyle(fontSize: 20)),
                              ]),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                  child: TextField(
                                textAlign: TextAlign.center,
                                controller: TranslateTextController,
                                decoration: InputDecoration(
                                  hintText: "請輸入譯文",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white12, width: 3.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lightBlue, width: 3.0),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              )),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            style: new ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.deepPurpleAccent)),
                            onPressed: () async {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return FutureBuilder(
                                        future: CrowdinAPI.addTranslation(
                                            Account.getToken(),
                                            SelectStringInfo['id'],
                                            TranslateTextController.text),
                                        builder: (context,
                                            AsyncSnapshot<Map?> snapshot) {
                                          if (snapshot.hasData) {
                                            Map? data = snapshot.data;
                                            if (data != null &&
                                                !data.containsKey('errors')) {
                                              return AlertDialog(
                                                title: Text("成功新增翻譯，感謝您的翻譯貢獻",
                                                    textAlign:
                                                        TextAlign.center),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        setView2State(() {});
                                                      },
                                                      child: Text("確定"))
                                                ],
                                              );
                                            } else if (data != null &&
                                                data.containsKey('errors')) {
                                              Map error = data['errors'][0]
                                                  ['error']['errors'][0];
                                              String errorMessage =
                                                  error['message'];
                                              String errorCode = error['code'];
                                              return AlertDialog(
                                                title: Text("新增翻譯失敗",
                                                    textAlign:
                                                        TextAlign.center),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text("錯誤代碼: $errorCode"),
                                                    Text("錯誤訊息: $errorMessage")
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("確定"))
                                                ],
                                              );
                                            } else {
                                              return AlertDialog(
                                                title: Text("發生未知錯誤",
                                                    textAlign:
                                                        TextAlign.center),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("確定"))
                                                ],
                                              );
                                            }
                                          } else {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        });
                                  });
                            },
                            child: Text(
                              "提交翻譯",
                              style: title_,
                            ),
                          )
                        ],
                      );
                    } else {
                      return Container();
                    }
                  })),
              SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("其他翻譯", style: TextStyle(fontSize: 22)),
                    Builder(builder: (context) {
                      final ScrollController
                          StringTranslationsScrollController =
                          ScrollController();
                      final PageController StringTranslationsPageController =
                          PageController(initialPage: 0);
                      if (SelectStringInfo != {} &&
                          SelectStringInfo.containsKey('id')) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 5,
                          child: PageView.builder(
                              controller: StringTranslationsPageController,
                              itemBuilder: (context, int Page) {
                                return FutureBuilder(
                                    future: CrowdinAPI.getStringTranslations(
                                        Account.getToken(),
                                        SelectStringInfo['id'],
                                        Page),
                                    builder: (context,
                                        AsyncSnapshot<List?> snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data != TranslationStrings) {
                                        TranslationStrings = snapshot.data!;
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.length,
                                            controller:
                                                StringTranslationsScrollController,
                                            itemBuilder: (context, index) {
                                              Map TranslationStringInfo =
                                                  TranslationStrings[index]
                                                      ['data'];
                                              String TranslationText =
                                                  TranslationStringInfo['text'];
                                              Map TranslationUser =
                                                  TranslationStringInfo['user'];
                                              bool IsMe =
                                                  TranslationUser['id'] ==
                                                      Account.getUserID();
                                              return ListTile(
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  child: Image.network(
                                                    TranslationUser[
                                                        "avatarUrl"],
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.fill,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child;
                                                      return CircularProgressIndicator(
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded
                                                                    .toInt() /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                                    .toInt()
                                                            : null,
                                                      );
                                                    },
                                                  ),
                                                ),
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      TranslationText,
                                                    ),
                                                    Text(
                                                        "${TranslationUser['username']} (${TranslationUser['fullName'] ?? ""})",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.blue)),
                                                  ],
                                                ),
                                                onTap: () {},
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons
                                                          .thumb_up_off_alt),
                                                      tooltip: "喜歡",
                                                      onPressed: () {},
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons
                                                          .thumb_down_off_alt),
                                                      tooltip: "不喜歡",
                                                      onPressed: () {},
                                                    )
                                                  ],
                                                ),
                                              );
                                            });
                                      } else {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                    });
                              }),
                        );
                      } else {
                        return Container();
                      }
                    }),
                  ],
                ),
              ),
            ],
            viewMode: SplitViewMode.Vertical,
            gripSize: 3,
          );
        }),
      );
    });
  }
}

class TranslateScreen extends StatefulWidget {
  final int FileID;
  final String FileName;
  const TranslateScreen({required this.FileID, required this.FileName});

  @override
  TranslateScreen_ createState() =>
      TranslateScreen_(FileID: FileID, FileName: FileName);
}
