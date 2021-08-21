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
    return data.containsKey('error') ? data : data['data'];
  }

  static Future<Response> basePost(String Token, String url, Map Json) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $Token'
    };
    Response response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(Json));
    return response;
  }

  static Future<List?> getModsByVersion(
      String Token, String Version, String filter, int Page) async {
    int DirID = RPMTWData.VersionDirID[Version] ?? 33894;
    filter = filter == "" ? "" : "&filter=$filter";
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/directories?directoryId=$DirID&offset=${Page * 20}&limit=20$filter";
    dynamic data = await baseGet(Token, url);

    return data;
  }

  static Future<List?> getFilesByDir(
      String Token, int DirID, String filter, int Page) async {
    filter = filter == "" ? "" : "&filter=$filter";
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/files?directoryId=$DirID&recursion&offset=${Page * 20}&limit=20$filter";
    dynamic data = await baseGet(Token, url);
    return data;
  }

  static Future<List?> getSourceStringByFile(
      String Token, int FileID, String filter, int Page) async {
    filter = filter == "" ? "" : "&filter=$filter";
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/strings?fileId=$FileID&offset=${Page * 20}&limit=20$filter";
    dynamic data = await baseGet(Token, url);
    return data;
  }

  static Future<Map?> addTranslation(
      String Token, int StringID, String text) async {
    String url = "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/translations";
    Response response = await basePost(Token, url, {
      "stringId": StringID,
      "languageId": RPMTWData.TraditionalChineseTaiwan, //繁體中文
      "text": text,
    });
    Map data = json.decode(response.body);
    return response.statusCode == 400
        ? data
        : data.containsKey('error')
            ? null
            : data['data'];
  }

  static Future<List?> getStringTranslations(String Token, int StringID) async {
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/translations?stringId=$StringID&languageId=${RPMTWData.TraditionalChineseTaiwan}&limit=20";
    dynamic data = await baseGet(Token, url);
    return data;
  }

  static Future<double> getProgressByFile(String Token, int FileID) async {
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/files/$FileID/languages/progress";
    List data = await baseGet(Token, url);
    Map Words = data[0]['data']['words'];
    return Words['total'] == 0 && Words['translated'] == 0
        ? 0
        : Words['translated'] / Words['total'];
  }

  static Future<List?> getTranslationVotes(
      String Token, int TranslationID, int StringID) async {
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/votes/?translationId=$TranslationID&stringId=$StringID&languageId=${RPMTWData.TraditionalChineseTaiwan}";
    dynamic data = await baseGet(Token, url);
    return data;
  }

  static int prserVote(List Votes) {
    int Num = 0;
    Votes.forEach((Vote) {
      if (Vote['data']['mark'] == "up") {
        Num++;
      } else if (Vote['data']['mark'] == "down") {
        Num--;
      }
    });
    return Num;
  }

  static Future<Map?> addVote(
      String Token, int TranslationID, String mark) async {
    String url = "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/votes";
    Response response = await basePost(
        Token, url, {"mark": mark, "translationId": TranslationID});
    Map data = json.decode(response.body);

    return data;
  }
}
