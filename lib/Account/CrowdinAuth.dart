// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

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
      return [Error, {}];
    }
  }
}
