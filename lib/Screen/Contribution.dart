// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rpmtranslator/API/RPMTWData.dart';
import 'package:rpmtranslator/Widget/OkClose.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class ContributionScreen_ extends State<ContributionScreen> {
  TextEditingController TokenController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("翻譯貢獻者排名 (一個月內)"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: "返回",
          onPressed: () {
            Navigator.pushNamed(
              context,
              HomePage.route,
            );
          },
        ),
        centerTitle: true,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder(
              future: RPMTWData.getContribution(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        Map data = snapshot.data[index];
                        Map user = data["user"];
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white12, width: 1),
                          ),
                          child: ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text((index + 1).toString(),
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.blue)),
                                SizedBox(
                                  width: 10,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(user['avatarUrl']),
                                ),
                              ],
                            ),
                            title: Text(user['fullName'],
                                style: TextStyle(fontSize: 30),
                                textAlign: TextAlign.center),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("詳細資訊",
                                          textAlign: TextAlign.center),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "翻譯字數: ${data['translated']}",
                                          ),
                                          Text(
                                            "投票次數: ${data['voted']}",
                                          ),
                                          Text(
                                            "翻譯獲得稱讚次數: ${data['winning']}",
                                          ),
                                          Text(
                                            "加入時間: ${RPMTWData.FormatIsoTime(user['joined'])}",
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              launch(
                                                  "https://crowdin.com/profile/${user['username']}");
                                            },
                                            child: Text("在Crowdin上查看")),
                                        OkClose()
                                      ],
                                    );
                                  });
                            },
                          ),
                        );
                      });
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })),
    );
  }
}

class ContributionScreen extends StatefulWidget {
  static String route = "/contribution";
  @override
  ContributionScreen_ createState() => ContributionScreen_();
}
