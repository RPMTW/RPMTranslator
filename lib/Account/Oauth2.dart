// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class Oauth2Handler {
  /*
  API Docs: https://support.crowdin.com/authorizing-oauth-apps/
   */
  Future AuthorizationXBL(String accessToken) async {
    print(accessToken);
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse(''));
    request.body = json.encode({

    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Map data = json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
