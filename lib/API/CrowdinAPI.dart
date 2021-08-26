// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace

import 'dart:convert';
import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:rpmtranslator/Account/Account.dart';
import 'package:universal_io/io.dart';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:rpmtranslator/API/APIs.dart';
import 'package:rpmtranslator/API/RPMTWData.dart';

class CrowdinAPI {
  static Future<dynamic> baseGet(String url, [headers_]) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Account.getToken()}',
    };
    if (headers_ != null) {
      headers.addAll(headers_);
    }
    headers.addAll(RPMTWData.UserAgent);
    Response response = await http.get(Uri.parse(url), headers: headers);
    Map data = json.decode(response.body);
    return data.containsKey('error') ? response : data['data'];
  }

  static Future<Response> basePost(String url, dynamic body, [headers_]) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Account.getToken()}'
    };
    if (headers_ != null) {
      headers.addAll(headers_);
    }
    headers.addAll(RPMTWData.UserAgent);
    Response response = await http.post(Uri.parse(url),
        headers: headers, body: body is Map ? json.encode(body) : body);
    return response;
  }

  static Future<Response> baseDelete(String url, [headers_]) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Account.getToken()}',
    };
    if (headers_ != null) {
      headers.addAll(headers_);
    }
    headers.addAll(RPMTWData.UserAgent);
    Response response = await http.delete(Uri.parse(url), headers: headers);
    return response;
  }

  static Future<dynamic> getMods(
      String Version, String filter, int Page, String SortItem) async {
    int DirID = RPMTWData.VersionDirID[Version] ?? 33894;

    switch (RPMTWData.SortItems.indexOf(SortItem)) {
      case 0: //依照模組ID搜尋
        filter = filter == "" ? "" : "&filter=$filter";
        break;
      case 1: //依照模組的CurseForge ID搜尋
        Map CrowdinIndex =
            await RPMTWData.getCrowdinIndex(double.parse(Version));
        String ModID = "";
        if (CrowdinIndex.containsKey(filter)) {
          ModID = CrowdinIndex[filter]['ModID'];
        }
        filter = ModID == "" ? "" : "&filter=$ModID";
        break;
      default:
        break;
    }
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/directories?directoryId=$DirID&offset=${Page * 20}&limit=20$filter";
    dynamic data = await baseGet(url);
    return data.runtimeType == Response
        ? (data.statusCode == 401
            ? json.decode(data.body)['error']['message']
            : null)
        : data;
  }

  static Future<List?> getFilesByDir(int DirID, String filter, int Page) async {
    filter = filter == "" ? "" : "&filter=$filter";
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/files?directoryId=$DirID&recursion&offset=${Page * 20}&limit=20$filter";
    dynamic data = await baseGet(url);
    return data;
  }

  static Future<List?> getSourceStringByFile(
      int FileID, String filter, int Page) async {
    filter = filter == "" ? "" : "&filter=$filter";
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/strings?fileId=$FileID&offset=${Page * 20}&limit=20$filter";
    dynamic data = await baseGet(url);
    return data;
  }

  static Future<Map?> addTranslation(int StringID, String text) async {
    String url = "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/translations";
    Response response = await basePost(url, {
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

  static Future<List?> getStringTranslations(int StringID) async {
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/translations?stringId=$StringID&languageId=${RPMTWData.TraditionalChineseTaiwan}&limit=20";
    dynamic data = await baseGet(url);
    return data;
  }

  static Future<double> getProgressByFile(int FileID) async {
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/files/$FileID/languages/progress";
    List data = await baseGet(url);
    Map Words = data[0]['data']['words'];
    return Words['total'] == 0 && Words['translated'] == 0
        ? 0
        : Words['translated'] / Words['total'];
  }

  static Future<double> getProgressByDirectory(int FileID) async {
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/directories/$FileID/languages/progress";
    List data = await baseGet(url);
    return data[0]['data']['translationProgress'] / 100;
  }

  static Future<List?> getTranslationVotes(
      int TranslationID, int StringID) async {
    String url =
        "$RPMCrowdinBaseAPI?url=/projects/${RPMTWData.CrowdinID}/votes/?translationId=$TranslationID&stringId=$StringID&languageId=${RPMTWData.TraditionalChineseTaiwan}";
    dynamic data = await baseGet(url, {'Access-Control-Allow-Headers': '*'});
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

  static Future<Map?> addVote(int TranslationID, String mark) async {
    String url = "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/votes";
    Response response =
        await basePost(url, {"mark": mark, "translationId": TranslationID});
    Map data = json.decode(response.body);

    return data;
  }

  static Future<List?> getCommentsByString(int StringID, int Page) async {
    String url =
        "$RPMCrowdinBaseAPI?url=/projects/${RPMTWData.CrowdinID}/comments/?stringId=$StringID&offset=${Page * 20}&limit=20";
    dynamic data = await baseGet(url, {'Access-Control-Allow-Headers': '*'});
    return data;
  }

  static Future<Map?> addComment(int StringID, String text, String Type,
      [issueType]) async {
    String url = "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/comments";

    Map Json = {
      "text": text,
      "stringId": StringID,
      "targetLanguageId": RPMTWData.TraditionalChineseTaiwan,
      "type": Type
    };

    if (issueType != null) {
      Json['issueType'] = issueType;
    }

    Response response = await basePost(url, Json);
    Map data = json.decode(response.body);
    return response.statusCode == 400
        ? data
        : data.containsKey('error')
            ? null
            : data['data'];
  }

  static Future<bool> updateTranslation(
      XFile file, int FileID, String FileName) async {
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/translations/${RPMTWData.TraditionalChineseTaiwan}";

    int? storageId =
        await CrowdinAPI.addStorage(await file.readAsBytes(), FileName);

    if (storageId == null) return false;

    Map Json = {"storageId": storageId, "fileId": FileID};

    Response response = await basePost(url, Json);
    Map data = json.decode(response.body);
    return response.statusCode == 200 ? true : false;
  }

  static Future<int?> addStorage(Uint8List fileBytes, String FileName) async {
    String url = "$CrowdinBaseAPI/storages";

    Response response = await basePost(url, fileBytes, {
      "Crowdin-API-FileName": FileName,
      "Content-Type": "application/octet-stream"
    });
    Map data = json.decode(response.body);
    return response.statusCode == 201 ? data['data']['id'] : null;
  }

  static Future<bool> downloadFile(
      int FileID, String path, String FileName) async {
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/files/$FileID/download";

    Map data = await baseGet(url);
    String downloadUrl = data['url'];
    await http.get(Uri.parse(downloadUrl)).then((response) async {
      final file = XFile.fromData(response.bodyBytes, name: FileName);
      await file.saveTo(path);
    });
    return true;
  }

  static Future<bool> deleteTranslation(int translationId) async {
    String url =
        "$CrowdinBaseAPI/projects/${RPMTWData.CrowdinID}/translations/$translationId";
    Response response = await baseDelete(url);
    print(response.statusCode == 204);
    return response.statusCode == 204;
  }
}
