// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace

import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:rpmtranslator/API/APIs.dart';
import 'package:rpmtranslator/API/RPMTWData.dart';
import 'package:rpmtranslator/Account/CrowdinAuth.dart';

class CrowdinAPI {
  static Future<dynamic> baseGet(String Token, String url) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $Token'
    };

    Map data =
        json.decode((await http.get(Uri.parse(url), headers: headers)).body);
    return data.containsKey('error') ? null : data['data'];
  }

  static Future<dynamic> basePost(String Token, String url, Map Json) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $Token'
    };

    Map data = json.decode((await http.post(Uri.parse(url),
            headers: headers, body: json.encode(Json)))
        .body);

    return data.containsKey('error') ? null : data['data'];
  }

  static Future<List?> getModsByVersion(
      String Token, String Version, String filter, int Page) async {
    int DirID = RPMTWDataHandler.VersionDirID[Version] ?? 33894;
    filter = filter == "" ? "" : "&filter=$filter";
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWDataHandler.CrowdinID}/directories?directoryId=$DirID&offset=${Page * 20}&limit=20$filter";
    dynamic data = await baseGet(Token, url);

    return data;
  }

   static Future<List?> getFilesByDir(
      String Token, int DirID, String filter, int Page) async {
    filter = filter == "" ? "" : "&filter=$filter";
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWDataHandler.CrowdinID}/files?directoryId=$DirID&recursion&offset=${Page * 20}&limit=20$filter";
    dynamic data = await baseGet(Token, url);
    return data;
  }

     static Future<List?> getSourceStringByFile(
      String Token, int FileID, String filter, int Page) async {
    filter = filter == "" ? "" : "&filter=$filter";
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWDataHandler.CrowdinID}/strings?fileId=$FileID&offset=${Page * 20}&limit=20$filter";
    dynamic data = await baseGet(Token, url);
    return data;
  }
}
