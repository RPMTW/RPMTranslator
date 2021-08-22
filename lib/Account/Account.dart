// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_final_fields

import 'dart:convert';

import '../path.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class Account {
  static io.Directory _ConfigFolder = configHome;
  static io.File AccountFile =
      io.File(join(_ConfigFolder.absolute.path, "accounts.json"));
  static Map _account = json.decode(AccountFile.readAsStringSync());

  static Map get() {
    return _account;
  }

  static void add(String Token, String RefreshToken, int UserID) {
    _account = {
      "AccessToken": Token,
      "RefreshToken": RefreshToken,
      "UserID": UserID,
      "Expired": false
    };
    save();
  }

  static bool has() {
    return _account.containsKey("AccessToken");
  }

  static bool expired() {
    return _account.containsKey('Expired') ? _account["Expired"] : false;
  }

  static String getToken() {
    return _account["AccessToken"];
  }

  static int getUserID() {
    return _account["UserID"];
  }

  static void logout() {
    _account = {};
    save();
  }

  static void save() {
    AccountFile.writeAsStringSync(json.encode(_account));
  }

  static void change(Map Json) {
    _account = Json;
    save();
  }
}
