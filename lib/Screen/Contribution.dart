// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rpmtranslator/API/RPMTWData.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class ContributionScreen_ extends State<ContributionScreen> {
  TextEditingController TokenController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  var title_ = TextStyle(
    fontSize: 25.0,
  );

  var title2_ = TextStyle(
    color: Colors.white60,
    fontSize: 18.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("翻譯貢獻者 (一個月內)"),
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
                  Size size = MediaQuery.of(context).size;

                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        Map data = snapshot.data[index];
                        Map user = data["user"];
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white12),
                          ),
                          child: InkWell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(user['avatarUrl']),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("第 $index 名",
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.blue)),
                                SizedBox(
                                  height: 50,
                                  width: user['fullName'].length * 15 > 300
                                      ? 300
                                      : user['fullName'].length * 15,
                                  child: AutoSizeText(user['fullName'],
                                      style: title_,
                                      textAlign: TextAlign.center),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("翻譯字數: ${data['translated']}",
                                    style: title2_),
                                Text("投票次數: ${data['voted']}", style: title2_),
                                Text("翻譯獲得稱讚次數: ${data['winning']}",
                                    style: title2_),
                                Text(
                                    "加入時間: ${RPMTWData.FormatIsoTime(user['joined'])}",
                                    style: title2_),
                              ],
                            ),
                            onTap: () {
                              launch(
                                  "https://crowdin.com/profile/${user['username']}");
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
