// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element, avoid_unnecessary_containers, use_key_in_widget_constructors, sized_box_for_whitespace, no_logic_in_create_state, curly_braces_in_flow_control_structures, unrelated_type_equality_checks, constant_identifier_names
import 'package:http/http.dart';
import 'package:html/parser.dart' show parse;

class DeeplAPI {
  static const int DeeplID = 18350051;

  static Future<String> Translation(String SrcText) async {
    Response response =
        await get(Uri.parse("https://www.deepl.com/translator#en/zh/$SrcText"));
    String body = response.body;

    String translation = parse(body)
        .getElementsByClassName(
            "lmt__notification__blocked_title")[0]
        .text
        .toString();
    print(translation);
    return translation;
  }
}
