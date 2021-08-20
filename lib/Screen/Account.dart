// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';

import '../main.dart';
import 'CrowdnlLogin.dart';

class AccountScreen_ extends State<AccountScreen> {
  late int choose_index;

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
    return new Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: '',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => new App()),
            );
          },
        ),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: new ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => MSLoginWidget(
                      builder: (BuildContext context, Client httpClient) {
                    return Center(
                      child: Text(
                        '成功登入微軟帳號',
                      ),
                    );
                  }),
                );
              },
              child: Text(
                '登入 Crowdin 帳號',
                textAlign: TextAlign.center,
                style: title_,
              ),
            ),
            Text(
              "tet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
          ])),
    );
  }
}

class AccountScreen extends StatefulWidget {
  @override
  AccountScreen_ createState() => AccountScreen_();
}
