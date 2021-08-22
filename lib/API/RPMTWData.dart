// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:http/http.dart';
import 'package:rpmtranslator/API/APIs.dart';

class RPMTWData {
  static List<String> VersionItems = ["1.17", "1.16", "1.12"];
  static Map<String, int> VersionDirID = {
    "1.12": 37104,
    "1.16": 14698,
    "1.17": 33894
  };
  static int CrowdinID = 442446;
  static String TraditionalChineseTaiwan = 'zh-TW';
  static String MarkUp = 'up';
  static String MarkDown = 'down';
  static Map<String, String> UserAgent = {'User-Agent': 'RPMTranslator'};
  static String Comment = 'comment';
  static String CommentIssue = 'issue';

  static Map<String, String> ErrorMessage = {
    "Forbidden": "沒有存取權限",
    "An identical translation of this string has been already saved. Vote for the existing translation instead of adding a new one.":
        "存在重複的翻譯"
  };

  static Future<Map> getProgress() async {
    Response response = await get(Uri.parse(RPMTWProgressAPI));
    Map data = json.decode(response.body);
    return data;
  }

  static Future<Map> getCurseForgeIndex(double VersionID) async {
    String GitVersion = VersionID == 1.16 ? "Original" : "Original-$VersionID";
    Response response = await get(Uri.parse(
        "https://raw.githubusercontent.com/RPMTW/ResourcePack-Mod-zh_tw/$GitVersion/$VersionID/CurseForgeIndex.json"));
    Map data = json.decode(response.body);
    return data;
  }

  static Future<Map> getCurseForgeAddonInfo(int CurseID) async {
    if (CurseID == 0) return {};
    Response response = await get(Uri.parse("$CurseForgeAPI/addon/$CurseID"));
    Map data = json.decode(response.body);
    return data;
  }

  static String TranslateErrorMessage(String Error) {
    return ErrorMessage.containsKey(Error)
        ? ErrorMessage[Error].toString()
        : Error;
  }

  static String FormatIsoTime(String IsoTime) {
    DateTime Time = DateTime.parse(IsoTime);

    return "${Time.year}年 ${Time.month}月 ${Time.day}日 ${Time.hour}時 ${Time.minute}分鐘 ${Time.second}秒";
  }
}
