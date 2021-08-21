// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:http/http.dart';
import 'package:rpmtranslator/API/APIs.dart';

class RPMTWDataHandler {
  static List<String> VersionItems = ["1.17", "1.16", "1.12"];
  static Map<String, int> VersionDirID = {
    "1.12": 37104,
    "1.16": 14698,
    "1.17": 33894
  };
  static int CrowdinID = 442446;

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
}
