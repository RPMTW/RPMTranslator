// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace, no_logic_in_create_state, curly_braces_in_flow_control_structures, unrelated_type_equality_checks, constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart';

class TranslationAPI {
  static Future<String?> TranslationWithModernMT(String SrcText) async {
    Response response = await get(Uri.parse(
        "https://webapi.modernmt.com/translate?source=en&target=zh-TW&q=$SrcText"));

    Map data = json.decode(response.body);
    return response.statusCode == 200 ? data['data']['translation'] : null;
  }

  static Future<String?> TranslationWithYandex(String SrcText) async {
    Response response = await post(
        Uri.parse(
            "https://translate.yandex.net/api/v1/tr.json/translate?id=eddea42b.61225856.e7d81e48.74722d74657874-6-0&srv=tr-text&lang=en-zh&reason=auto&format=text&yu=6401904741629630991"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: "text=$SrcText");

    Map data = json.decode(response.body);
    return response.statusCode == 200 ? data['text'][0] : null;
  }
}
