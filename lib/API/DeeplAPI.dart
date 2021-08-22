// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace, no_logic_in_create_state, curly_braces_in_flow_control_structures, unrelated_type_equality_checks, constant_identifier_names
import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:rpmtranslator/API/RPMTWData.dart';

class DeeplAPI {
  static const int DeeplID = 42770012;

  static Future<String> Translation(String SrcText) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'LMTBID=v2|f5ff200d-a955-4873-a437-1882578c778f|71dc01986f9c43b744f2f3b82cf527b7'
    };
    // headers.addAll(RPMTWData.UserAgent);

    Response response = await http.post(
        Uri.parse("https://www2.deepl.com/jsonrpc?method=LMT_handle_jobs"),
        headers: headers,
        body: json.encode({
          "jsonrpc": "2.0",
          "method": "LMT_handle_jobs",
          "params": {
            "jobs": [
              {"kind": "default", "raw_en_sentence": SrcText, "quality": "fast"}
            ],
            "lang": {"source_lang_user_selected": "EN", "target_lang": "ZH"},
            "timestamp": 1629608587035
          },
          "id": DeeplID
        }));

    if (response.statusCode == 200) {
      return json.decode(response.body)['result']['translations'][0]['beams'][0]
          ['postprocessed_sentence'];
    } else if (response.statusCode == 429) {
      throw new Exception("Too many Requests");
    } else {
      print(response.reasonPhrase);
      throw new Exception("Failure to translate using Deepl");
    }
  }
}
