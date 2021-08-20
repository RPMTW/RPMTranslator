// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'package:url_launcher/url_launcher.dart';

class utility{
  static Future<void> OpenUrl(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      print("Can't open the url $url");
    }
  }
}