// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace, no_logic_in_create_state, curly_braces_in_flow_control_structures, unrelated_type_equality_checks, prefer_typing_uninitialized_variables
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:rpmtranslator/API/CrowdinAPI.dart';
import 'package:rpmtranslator/API/TranslationAPI.dart';
import 'package:rpmtranslator/API/RPMTWData.dart';
import 'package:rpmtranslator/Account/Account.dart';
import 'package:rpmtranslator/Utility/utility.dart';
import 'package:rpmtranslator/Widget/OkClose.dart';
import 'package:split_view/split_view.dart';
import 'package:translator/translator.dart';

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
  int View3SelectedIndex = -1;
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
                                            controller: ScrollController(),
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
                                                  View3SelectedIndex = 0;
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
                      ]),
                    ),
                    Builder(builder: (context) {
                      switch (View3SelectedIndex) {
                        case 0:
                          return CommentView(
                              SelectStringInfo: SelectStringInfo,
                              CommentTextController: CommentTextController,
                              TranslateTextController: TranslateTextController,
                              setView3State: setView3State,
                              title_: title_);
                        case 1:
                          return Text("詞彙");
                        default:
                          return Container();
                      }
                    })
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
              Container(
                  child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: MachineTranslation(
                          SelectStringInfo: SelectStringInfo))),
            ],
            controller: SplitViewController(weights: [0.45, 0.25, 0.30]),
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

class MachineTranslation extends StatelessWidget {
  final Map SelectStringInfo;

  const MachineTranslation({
    required this.SelectStringInfo,
    Key? key,
  }) : super(key: key);

  static final translator = GoogleTranslator();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (SelectStringInfo.containsKey('text')) {
        return Column(
          children: [
            Text("機器翻譯", style: TextStyle(fontSize: 22)),
            FutureBuilder(
                future:
                    translator.translate(SelectStringInfo['text'], to: 'zh-tw'),
                builder: (context, AsyncSnapshot GoogleSnapshot) {
                  if (GoogleSnapshot.hasData) {
                    return Tooltip(
                      message: "複製譯文",
                      child: ListTile(
                          leading: Image.network(
                              'https://www.google.com/favicon.ico'),
                          title: Text(GoogleSnapshot.data.text),
                          subtitle: Text("由 Google 翻譯提供"),
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: GoogleSnapshot.data.text));
                          }),
                    );
                  } else if (GoogleSnapshot.hasError) {
                    return Text("取得 Google 翻譯失敗，錯誤原因 ${GoogleSnapshot.error}");
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            FutureBuilder(
                future: TranslationAPI.TranslationWithModernMT(
                    SelectStringInfo['text']),
                builder: (context, AsyncSnapshot ModernMTSnapshot) {
                  if (ModernMTSnapshot.hasData) {
                    return Tooltip(
                      message: "複製譯文",
                      child: ListTile(
                          leading: Image.network(
                              'https://www.modernmt.com/assets/images/favicon/favicon.ico'),
                          title: Text(ModernMTSnapshot.data),
                          subtitle: Text("由 ModernMT 翻譯提供"),
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: ModernMTSnapshot.data));
                          }),
                    );
                  } else if (ModernMTSnapshot.hasError) {
                    return Text(
                        "取得 ModernMT 翻譯失敗，錯誤原因 ${ModernMTSnapshot.error}");
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            FutureBuilder(
                future: TranslationAPI.TranslationWithYandex(
                    SelectStringInfo['text']),
                builder: (context, AsyncSnapshot YandexSnapshot) {
                  if (YandexSnapshot.hasData) {
                    return Tooltip(
                      message: "複製譯文",
                      child: ListTile(
                          leading: Image.network(
                              'https://translate.yandex.com/icons/favicon.ico'),
                          title: Text(YandexSnapshot.data),
                          subtitle: Text("由 Yandex 翻譯提供"),
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: YandexSnapshot.data));
                          }),
                    );
                  } else if (YandexSnapshot.hasError) {
                    return Text("取得 Yandex 翻譯失敗，錯誤原因 ${YandexSnapshot.error}");
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })
          ],
        );
      } else {
        return Container();
      }
    });
  }
}

class CommentView extends StatelessWidget {
  const CommentView({
    Key? key,
    required this.SelectStringInfo,
    required this.CommentTextController,
    required this.TranslateTextController,
    required this.setView3State,
    required this.title_,
  }) : super(key: key);

  final Map SelectStringInfo;
  final TextEditingController CommentTextController;
  final TextEditingController TranslateTextController;
  final StateSetter setView3State;
  final TextStyle title_;
  static var CommentsSnapshot;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (SelectStringInfo.containsKey('text')) {
        return FutureBuilder(
            future: CrowdinAPI.getCommentsByString(
                Account.getToken(), SelectStringInfo['id'], 0),
            builder: (context, AsyncSnapshot CommentsSnapshot_) {
              if (CommentsSnapshot_.hasData &&
                  CommentsSnapshot != CommentsSnapshot_.data) {
                CommentsSnapshot = CommentsSnapshot_.data;
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            itemCount: CommentsSnapshot.length,
                            shrinkWrap: true,
                            itemBuilder: (context, int Index) {
                              Map Comment = CommentsSnapshot[Index]['data'];
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
                                              title: Text("新增討論失敗",
                                                  textAlign: TextAlign.center),
                                              content: Text("討論內文不能是空的"),
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
                                                future: CrowdinAPI.addComment(
                                                  Account.getToken(),
                                                  SelectStringInfo['id'],
                                                  CommentTextController.text,
                                                  RPMTWData.Comment,
                                                ),
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
                                                            "成功新增討論，感謝您的貢獻",
                                                            textAlign: TextAlign
                                                                .center),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                setView3State(
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
                                                        title: Text("新增討論失敗",
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
              } else if (CommentsSnapshot_.hasError) {
                return Text("取得討論失敗，錯誤原因 ${CommentsSnapshot_.error}");
              } else {
                return Center(child: CircularProgressIndicator());
              }
            });
      } else {
        return Container();
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
