// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rpmtranslator/API/RPMTWData.dart';

import '../main.dart';

class ProgressScreen_ extends State<ProgressScreen> {
  TextEditingController TokenController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  var title_ = TextStyle(
    fontSize: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("模組翻譯進度"),
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
      body: Center(
          child: FutureBuilder(
              future: RPMTWData.getProgress(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  Size size = MediaQuery.of(context).size;

                  Map data = snapshot.data;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProgressCard(
                          Title: "全版本",
                          Values: data['progress'],
                          progress: data['progress'],
                          size: size),
                      ProgressCard(
                          Title: "1.12",
                          Values: data['1.12'],
                          progress: data['1.12'],
                          size: size),
                      ProgressCard(
                          Title: "1.16",
                          Values: data['1.16'],
                          progress: data['1.16'],
                          size: size),
                      ProgressCard(
                          Title: "1.17",
                          Values: data['1.17'],
                          progress: data['1.17'],
                          size: size),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })),
    );
  }
}

class ProgressCard extends StatefulWidget {
  final String Title;
  final String Values;
  final String progress;
  final Size size;

  const ProgressCard({
    required this.Title,
    required this.Values,
    required this.progress,
    required this.size,
  });

  @override
  // ignore: no_logic_in_create_state
  ProgressCard_ createState() => ProgressCard_(
      Title: Title, Values: Values, progress: progress, size: size);
}

class ProgressCard_ extends State<ProgressCard> with TickerProviderStateMixin {
  final String Title;
  final String Values;
  final String progress;
  final Size size;

  ProgressCard_({
    required this.Title,
    required this.Values,
    required this.progress,
    required this.size,
  });

  late AnimationController controller;
  late double progress_;

  @override
  void initState() {
    progress_ = double.parse(progress.split("%").join("")) / 100;

    controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
        upperBound: progress_)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.deepPurpleAccent,
        child: Row(
          children: [
            SizedBox(width: size.width / 55),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: size.height / 28),
                SizedBox(
                  width: size.width / 15,
                  height: size.height / 25,
                  child: AutoSizeText(Title,
                      style: TextStyle(fontSize: 50, color: Colors.greenAccent),
                      textAlign: TextAlign.center),
                ),
                SizedBox(
                  width: size.width / 15,
                  height: size.height / 23,
                  child: AutoSizeText(Values,
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center),
                ),
                SizedBox(height: size.height / 60),
                Container(
                  width: size.width / 12,
                  height: size.height / 50,
                  alignment: Alignment.center,
                  child: LinearProgressIndicator(
                    value: controller.value,
                    color: Colors.cyan,
                    minHeight: 18,
                  ),
                ),
                SizedBox(height: size.width / 65),
              ],
            ),
            SizedBox(width: size.width / 55),
          ],
        ));
  }
}

class ProgressScreen extends StatefulWidget {
  static String route = "/progress";
  @override
  ProgressScreen_ createState() => ProgressScreen_();
}
