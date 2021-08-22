// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace, no_logic_in_create_state, curly_braces_in_flow_control_structures, unrelated_type_equality_checks
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:rpmtranslator/API/CrowdinAPI.dart';
import 'package:rpmtranslator/API/DeeplAPI.dart';
import 'package:rpmtranslator/API/RPMTWData.dart';
import 'package:rpmtranslator/Account/Account.dart';
import 'package:rpmtranslator/Utility/utility.dart';
import 'package:rpmtranslator/Widget/OkClose.dart';
import 'package:split_view/split_view.dart';

class TranslateScreen_ extends State<TranslateScreen> {
  final TextEditingController SearchController = TextEditingController();
  final TextEditingController TranslateTextController = TextEditingController();
  final TextEditingController CommentTextController = TextEditingController();
  final PageController TranslatePageController = PageController(initialPage: 0);
  int TranslateListLength = 0;

  final int FileID;
  final String FileName;
  int SelectIndex = -1;
  int StringPage = 0;
  Map SelectStringInfo = {};
  int View3SelectedIndex = 0;
  late StateSetter setView3State;
  late StateSetter setView2State;
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
          toolbarHeight: 80,
          title: Column(
            children: [
              Text("$FileName - 翻譯頁面"),
              FutureBuilder(
                  future:
                      CrowdinAPI.getProgressByFile(Account.getToken(), FileID),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          LinearProgressIndicator(
                            color: Colors.blue,
                            value: snapshot.data,
                          ),
                          Text((snapshot.data * 100).toStringAsFixed(2) + "%")
                        ],
                      );
                    } else {
                      return LinearProgressIndicator();
                    }
                  })
            ],
          ),
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
                        Expanded(
                            child: TextField(
                          textAlign: TextAlign.center,
                          controller: SearchController,
                          decoration: InputDecoration(
                            hintText: "搜尋字串...",
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
                                                leading: FutureBuilder(
                                                    future: CrowdinAPI
                                                        .getStringTranslations(
                                                      Account.getToken(),
                                                      StringInfo['id'],
                                                    ),
                                                    builder: (context,
                                                        AsyncSnapshot
                                                            snapshot) {
                                                      if (snapshot.hasData) {
                                                        if (snapshot
                                                                .data.length >
                                                            0) {
                                                          return ColoredBox(
                                                              color:
                                                                  Colors.green,
                                                              child: SizedBox(
                                                                width: 20,
                                                                height: 20,
                                                              ));
                                                        } else {
                                                          return ColoredBox(
                                                              color: Colors.red,
                                                              child: SizedBox(
                                                                width: 20,
                                                                height: 20,
                                                              ));
                                                        }
                                                      } else {
                                                        return CircularProgressIndicator();
                                                      }
                                                    }),
                                                title: Text(SourceString),
                                                onTap: () {
                                                  SelectIndex = index;
                                                  SelectStringInfo = StringInfo;
                                                  setModListState(() {});
                                                  setView2State(() {});
                                                  setView3State(() {});
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
              StatefulBuilder(builder: (context, setView3State_) {
                setView3State = setView3State_;
                return SplitView(
                  viewMode: SplitViewMode.Vertical,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Expanded(
                          child: ListTile(
                            title: AutoSizeText("討論區"),
                            leading: Icon(Icons.comment),
                            onTap: () {
                              View3SelectedIndex = 0;
                              setView3State(() {});
                            },
                            tileColor: View3SelectedIndex == 0
                                ? Colors.white12
                                : Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: AutoSizeText("詞彙表"),
                            leading: Icon(
                              Icons.book,
                            ),
                            onTap: () {
                              View3SelectedIndex = 1;
                              setView3State(() {});
                            },
                            tileColor: View3SelectedIndex == 1
                                ? Colors.white12
                                : Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: AutoSizeText("機器翻譯"),
                            leading: Icon(Icons.translate),
                            onTap: () {
                              View3SelectedIndex = 2;
                              setView3State(() {});
                            },
                            tileColor: View3SelectedIndex == 2
                                ? Colors.white12
                                : Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      ]),
                    ),
                    Focus(
                        autofocus: true,
                        child: View3Widgets[View3SelectedIndex])
                  ],
                  controller: SplitViewController(
                      weights: [0.05],
                      limits: [WeightLimit(max: 0.05, min: 0.05)]),
                  gripSize: 2,
                );
              })
            ],
            controller: SplitViewController(weights: [
              0.2,
              0.58
            ], limits: [
              WeightLimit(max: 0.4, min: 0.2),
              WeightLimit(max: 0.7, min: 0.3)
            ]),
            gripSize: 3,
            viewMode: SplitViewMode.Horizontal));
  }

  late List<Widget> View3Widgets = [
    Builder(builder: (context) {
      print(SelectStringInfo);
      if (SelectStringInfo.containsKey('text')) {
        print("test2");
        return FutureBuilder(
            future: CrowdinAPI.getCommentsByString(
                Account.getToken(), SelectStringInfo['id'], 0),
            builder: (context, AsyncSnapshot CommentsSnapshot) {
              if (CommentsSnapshot.hasData) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            itemCount: CommentsSnapshot.data.length,
                            shrinkWrap: true,
                            itemBuilder: (context, int Index) {
                              Map Comment =
                                  CommentsSnapshot.data[Index]['data'];
                              Map CommentUser = Comment['user'];
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Image.network(
                                    CommentUser["avatarUrl"],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.fill,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Comment['text'],
                                    ),
                                    Text(
                                        "${CommentUser['username']} (${CommentUser['fullName'] ?? ""})",
                                        style: TextStyle(color: Colors.blue)),
                                    Text(
                                        RPMTWData.FormatIsoTime(
                                            Comment['createdAt']),
                                        style: TextStyle(color: Colors.white70))
                                  ],
                                ),
                                subtitle: Comment['type'] == 'issue'
                                    ? Comment['issueStatus'] == 'unresolved'
                                        ? Text("未解決")
                                        : Text("已解決")
                                    : Container(),
                                tileColor: Comment['type'] == 'issue' &&
                                        Comment['issueStatus'] == 'unresolved'
                                    ? Colors.red
                                    : Theme.of(context).scaffoldBackgroundColor,
                                onTap: () {},
                              );
                            }),
                        SizedBox(
                          height: 30,
                        ),
                        Text("討論", style: TextStyle(fontSize: 25)),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textAlign: TextAlign.center,
                              controller: CommentTextController,
                              decoration: InputDecoration(
                                hintText: "新增討論...",
                                hintStyle: TextStyle(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white12, width: 3.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.lightBlue, width: 3.0),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20.0),
                                border: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            )),
                            SizedBox(
                              width: 15,
                            ),
                            ElevatedButton(
                              style: new ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.deepPurpleAccent)),
                              onPressed: () async {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) =>
                                        Builder(builder: (context) {
                                          if (CommentTextController
                                              .text.isEmpty) {
                                            return AlertDialog(
                                              title: Text("新增翻譯失敗",
                                                  textAlign: TextAlign.center),
                                              content: Text("譯文不能是空的"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("確定"))
                                              ],
                                            );
                                          } else {
                                            return FutureBuilder(
                                                future:
                                                    CrowdinAPI.addTranslation(
                                                        Account.getToken(),
                                                        SelectStringInfo['id'],
                                                        TranslateTextController
                                                            .text),
                                                builder: (context,
                                                    AsyncSnapshot<Map?>
                                                        snapshot) {
                                                  if (snapshot.hasData) {
                                                    Map? data = snapshot.data;
                                                    if (data != null &&
                                                        !data.containsKey(
                                                            'errors')) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "成功新增翻譯，感謝您的翻譯貢獻",
                                                            textAlign: TextAlign
                                                                .center),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                setView2State(
                                                                    () {});
                                                              },
                                                              child: Text("確定"))
                                                        ],
                                                      );
                                                    } else if (data != null &&
                                                        data.containsKey(
                                                            'errors')) {
                                                      Map error = data['errors']
                                                              [0]['error']
                                                          ['errors'][0];
                                                      String errorMessage =
                                                          error['message'];
                                                      String errorCode =
                                                          error['code'];
                                                      return AlertDialog(
                                                        title: Text("新增翻譯失敗",
                                                            textAlign: TextAlign
                                                                .center),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                                "錯誤代碼: $errorCode"),
                                                            Text(
                                                                "錯誤訊息: ${RPMTWData.TranslateErrorMessage(errorMessage)}")
                                                          ],
                                                        ),
                                                        actions: [OkClose()],
                                                      );
                                                    } else {
                                                      return AlertDialog(
                                                        title: Text("發生未知錯誤",
                                                            textAlign: TextAlign
                                                                .center),
                                                        actions: [OkClose()],
                                                      );
                                                    }
                                                  } else {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  }
                                                });
                                          }
                                        }));
                              },
                              child: Text(
                                "送出",
                                style: title_,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else if (CommentsSnapshot.hasError) {
                return Text("取得討論失敗，錯誤原因 ${CommentsSnapshot.error}");
              } else {
                return Center(child: CircularProgressIndicator());
              }
            });
      } else {
        return Container();
      }
    }),
    Text("詞彙"),
    Builder(builder: (context) {
      return Container();
      // if (SelectStringInfo.containsKey('text')) {
      //   return FutureBuilder(
      //       future: DeeplAPI.Translation(SelectStringInfo['text']),
      //       builder: (context, AsyncSnapshot DeeplSnapshot) {
      //         if (DeeplSnapshot.hasData) {
      //           return Text(DeeplSnapshot.data);
      //         } else if (DeeplSnapshot.hasError) {
      //           return Text("取得機器翻譯失敗，錯誤原因 ${DeeplSnapshot.error}");
      //         } else {
      //           return Center(child: CircularProgressIndicator());
      //         }
      //       });
      // } else {
      //   return Container();
      // }
    }),
  ];

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
                  child: SingleChildScrollView(
                    controller: ScrollController(),
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
                                IconButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: SelectStringInfo['text']));
                                  },
                                  icon: Icon(Icons.copy_outlined),
                                  tooltip: "複製原文",
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            AutoSizeText("原文",
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 20)),
                            AutoSizeText(
                              SelectStringInfo['text'],
                            ),
                            AutoSizeText("語系鍵",
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 20)),
                            AutoSizeText(
                              SelectStringInfo['context'] == null
                                  ? "無"
                                  : SelectStringInfo['context']
                                      .toString()
                                      .split("-> ")
                                      .join(""),
                            ),
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
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textAlign: TextAlign.center,
                                  controller: TranslateTextController,
                                  decoration: InputDecoration(
                                    hintText: "譯文...",
                                    hintStyle: TextStyle(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white12, width: 3.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.lightBlue, width: 3.0),
                                    ),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    border: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                )),
                                SizedBox(
                                  width: 15,
                                ),
                                ElevatedButton(
                                  style: new ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.deepPurpleAccent)),
                                  onPressed: () async {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) =>
                                            Builder(builder: (context) {
                                              if (TranslateTextController
                                                  .text.isEmpty) {
                                                return AlertDialog(
                                                  title: Text("新增翻譯失敗",
                                                      textAlign:
                                                          TextAlign.center),
                                                  content: Text("譯文不能是空的"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("確定"))
                                                  ],
                                                );
                                              } else {
                                                return FutureBuilder(
                                                    future: CrowdinAPI
                                                        .addTranslation(
                                                            Account.getToken(),
                                                            SelectStringInfo[
                                                                'id'],
                                                            TranslateTextController
                                                                .text),
                                                    builder: (context,
                                                        AsyncSnapshot<Map?>
                                                            snapshot) {
                                                      if (snapshot.hasData) {
                                                        Map? data =
                                                            snapshot.data;
                                                        if (data != null &&
                                                            !data.containsKey(
                                                                'errors')) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "成功新增翻譯，感謝您的翻譯貢獻",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    setView2State(
                                                                        () {});
                                                                  },
                                                                  child: Text(
                                                                      "確定"))
                                                            ],
                                                          );
                                                        } else if (data !=
                                                                null &&
                                                            data.containsKey(
                                                                'errors')) {
                                                          Map error =
                                                              data['errors']
                                                                          [0]
                                                                      ['error']
                                                                  ['errors'][0];
                                                          String errorMessage =
                                                              error['message'];
                                                          String errorCode =
                                                              error['code'];
                                                          return AlertDialog(
                                                            title: Text(
                                                                "新增翻譯失敗",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                    "錯誤代碼: $errorCode"),
                                                                Text(
                                                                    "錯誤訊息: ${RPMTWData.TranslateErrorMessage(errorMessage)}")
                                                              ],
                                                            ),
                                                            actions: [
                                                              OkClose()
                                                            ],
                                                          );
                                                        } else {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "發生未知錯誤",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                            actions: [
                                                              OkClose()
                                                            ],
                                                          );
                                                        }
                                                      } else {
                                                        return Center(
                                                            child:
                                                                CircularProgressIndicator());
                                                      }
                                                    });
                                              }
                                            }));
                                  },
                                  child: Text(
                                    "提交",
                                    style: title_,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }),
                  )),
              SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("其他翻譯", style: TextStyle(fontSize: 22)),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 5,
                      child: Builder(builder: (context) {
                        final ScrollController
                            StringTranslationsScrollController =
                            ScrollController();
                        final PageController StringTranslationsPageController =
                            PageController(initialPage: 0);
                        if (SelectStringInfo != {} &&
                            SelectStringInfo.containsKey('id')) {
                          return Container(
                            child: FutureBuilder(
                                future: CrowdinAPI.getStringTranslations(
                                  Account.getToken(),
                                  SelectStringInfo['id'],
                                ),
                                builder:
                                    (context, AsyncSnapshot<List?> snapshot) {
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
                                              TranslationStrings[index]['data'];
                                          String TranslationText =
                                              TranslationStringInfo['text'];
                                          Map TranslationUser =
                                              TranslationStringInfo['user'];
                                          bool IsMe = TranslationUser['id'] ==
                                              Account.getUserID();
                                          return ListTile(
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                child: Image.network(
                                                  TranslationUser["avatarUrl"],
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.fill,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
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
                                                          color: Colors.blue)),
                                                  Text(
                                                      RPMTWData.FormatIsoTime(
                                                          TranslationStringInfo[
                                                              'createdAt']),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white70))
                                                ],
                                              ),
                                              onTap: () {},
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Votes(TranslationStringInfo,
                                                      IsMe, setView2State_),
                                                  IconButton(
                                                    onPressed: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text:
                                                                  TranslationText));
                                                    },
                                                    icon: Icon(
                                                        Icons.copy_outlined),
                                                    tooltip: "複製譯文",
                                                  ),
                                                ],
                                              ));
                                        });
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                }),
                          );
                        } else {
                          return Container();
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ],
            controller: SplitViewController(weights: [0.7, 0.3]),
            viewMode: SplitViewMode.Vertical,
            gripSize: 2,
            gripColor: Colors.white12,
          );
        }),
      );
    });
  }

  Widget Votes(Map<dynamic, dynamic> TranslationStringInfo, bool IsMe,
      StateSetter setView2State_) {
    return FutureBuilder(
        future: CrowdinAPI.getTranslationVotes(Account.getToken(),
            TranslationStringInfo['id'], SelectStringInfo['id']),
        builder: (context, AsyncSnapshot TranslationVotesSnapshot) {
          if (TranslationVotesSnapshot.hasData) {
            List TranslationVotes = TranslationVotesSnapshot.data;
            return Row(children: [
              Text(CrowdinAPI.prserVote(TranslationVotes).toString(),
                  style: TextStyle(fontSize: 18)),
              IconButton(
                icon: Icon(TranslationVotes.any((Vote) =>
                        TranslationVotes[0]['data']['user']['id'] ==
                        Account.getUserID())
                    ? Icons.thumb_up
                    : Icons.thumb_up_off_alt),
                tooltip: "我喜歡",
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        if (IsMe) {
                          return AlertDialog(
                            title: Text("按讚失敗"),
                            content: Text("您不能按讚自己的翻譯"),
                            actions: [OkClose()],
                          );
                        } else {
                          return FutureBuilder(
                              future: CrowdinAPI.addVote(
                                  Account.getToken(),
                                  TranslationStringInfo['id'],
                                  RPMTWData.MarkUp),
                              builder: (context, AsyncSnapshot<Map?> snapshot) {
                                if (snapshot.hasData &&
                                    !snapshot.data!.containsKey('error')) {
                                  setView2State_(() {});
                                  return AlertDialog(
                                    title: Text("按讚成功"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("確定"))
                                    ],
                                  );
                                } else if (snapshot.hasData &&
                                    snapshot.data!.containsKey('error')) {
                                  return AlertDialog(
                                    title: Text("按讚失敗"),
                                    content: Text(
                                        "錯誤原因: ${RPMTWData.TranslateErrorMessage(snapshot.data!['error']['message'])}"),
                                    actions: [OkClose()],
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              });
                        }
                      });
                },
              ),
              IconButton(
                icon: Icon(TranslationVotes.any((Vote) =>
                        TranslationVotes[0]['data']['user']['id'] ==
                        Account.getUserID())
                    ? Icons.thumb_down
                    : Icons.thumb_down_off_alt),
                tooltip: "我不喜歡",
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        if (IsMe) {
                          return AlertDialog(
                            title: Text("到讚失敗"),
                            content: Text("您不能到讚自己的翻譯"),
                            actions: [OkClose()],
                          );
                        } else {
                          return FutureBuilder(
                              future: CrowdinAPI.addVote(
                                  Account.getToken(),
                                  TranslationStringInfo['id'],
                                  RPMTWData.MarkDown),
                              builder: (context, AsyncSnapshot<Map?> snapshot) {
                                if (snapshot.hasData &&
                                    !snapshot.data!.containsKey('error')) {
                                  setView2State_(() {});
                                  return AlertDialog(
                                    title: Text("到讚成功"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("確定"))
                                    ],
                                  );
                                } else if (snapshot.hasData &&
                                    snapshot.data!.containsKey('error')) {
                                  return AlertDialog(
                                    title: Text("到讚失敗"),
                                    content: Text(
                                        "錯誤原因: ${RPMTWData.TranslateErrorMessage(snapshot.data!['error']['message'])}"),
                                    actions: [OkClose()],
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              });
                        }
                      });
                },
              )
            ]);
          } else {
            return Center(child: CircularProgressIndicator());
          }
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
