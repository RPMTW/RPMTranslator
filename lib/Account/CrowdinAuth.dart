// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:rpmtranslator/API/APIs.dart';
import 'package:rpmtranslator/API/RPMTWData.dart';
import 'package:rpmtranslator/Account/Account.dart';

class CrowdinAuthHandler {
  /*
  API Docs: https://support.crowdin.com/api/v2/
   */

  static String Success = 'success';
  static String Error = 'error';

  static Future<List> CheckToken(String accessToken) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    var request =
        http.Request('GET', Uri.parse('https://api.crowdin.com/api/v2/user'));
    request.body = json.encode({});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
      return [Success, data];
    } else {
      print(response.reasonPhrase);
      return [];
    }
  }

  static Future<bool> RefreshToken(String refreshToken) async {
    Map<String, String> headers = {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json',
    };
    headers.addAll(RPMTWData.UserAgent);
    Response response = await http.get(
      Uri.parse(
          "https://rear-end.a102009102009.repl.co/crowdin/auth/refreshToken?refreshToken=$refreshToken"),
      headers: headers,
    );
    Map data = json.decode(response.body);
    if (response.statusCode == 200) {
      Map account = Account.get();
      Account.change({
        "AccessToken": data["access_token"],
        "RefreshToken": data['refresh_token'],
        "UserID": account['UserID'],
        "Expired": false
      });
      return true;
    } else {
      return false;
    }
  }
}
