// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace, no_logic_in_create_state
import 'package:flutter/material.dart';
import 'package:rpmtranslator/API/CrowdinAPI.dart';
import 'package:rpmtranslator/Account/Account.dart';
import 'package:rpmtranslator/Widget/AccountNone.dart';
import 'package:split_view/split_view.dart';

class TranslateScreen_ extends State<TranslateScreen> {
  final TextEditingController SearchController = TextEditingController();
  final ScrollController TranslateScrollController = ScrollController();
  final PageController TranslatePageController = PageController(initialPage: 0);
  int TranslateListLength = 0;

  final int FileID;
  final String FileName;
  int SelectIndex = 0;
  int StringPage = 0;

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
        body: SplitView(children: [
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
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
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
                                              setModListState(() {});
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
                                duration: const Duration(milliseconds: 300));
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
                                duration: const Duration(milliseconds: 300));
                            setChangePageState(() {});
                          },
                          icon: Icon(Icons.navigate_next))
                    ],
                  );
                })
              ],
            ),
          ),
          Container(
            child: Center(child: Text("翻譯界面")),
          ),
          Container(
            child: Center(child: Text("資料庫...")),
          ),
        ], gripSize: 3, viewMode: SplitViewMode.Horizontal));
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
