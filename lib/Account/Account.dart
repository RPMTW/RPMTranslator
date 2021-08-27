// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_final_fields

import 'dart:convert';
import 'package:universal_html/html.dart';

import 'package:flutter/foundation.dart';
import 'package:rpmtranslator/main.dart';

import '../path.dart';
import 'package:universal_io/io.dart' as io;
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
    if (kIsWeb) {
      window.localStorage.addAll({
        "AccessToken": Token,
        "RefreshToken": RefreshToken,
        "UserID": UserID.toString(),
        "Expired": false.toString()
      });
    } else {
      _account = {
        "AccessToken": Token,
        "RefreshToken": RefreshToken,
        "UserID": UserID,
        "Expired": false
      };
    }
    save();
  }

  static bool has() {
    if (kIsWeb) {
      return window.localStorage.containsKey("AccessToken");
    } else {
      return _account.containsKey("AccessToken");
    }
  }

  static bool expired() {
    if (kIsWeb) {
      return window.localStorage.containsKey('Expired')
          ? window.localStorage["Expired"].toString().parseBool()
          : false;
    } else {
      return _account.containsKey('Expired') ? _account["Expired"] : false;
    }
  }

  static void setExpired(bool s) {
    if (kIsWeb) {
      window.localStorage["Expired"] = s.toString();
    } else {
      _account["Expired"] = s;
    }
    save();
  }

  static String getToken() {
    if (kIsWeb) {
      return window.localStorage["AccessToken"].toString();
    } else {
      return _account["AccessToken"];
    }
  }

  static String getRefreshToken() {
    if (kIsWeb) {
      return window.localStorage["RefreshToken"].toString();
    } else {
      return _account["RefreshToken"];
    }
  }

  static int getUserID() {
    if (kIsWeb) {
      return int.parse(window.localStorage["UserID"].toString());
    } else {
      return _account["UserID"];
    }
  }

  static void logout() {
    if (kIsWeb) return window.localStorage.clear();
    _account = {};
    save();
  }

  static void save() {
    if (kIsWeb) return;
    AccountFile.writeAsStringSync(json.encode(_account));
  }

  static void change(Map Json) {
    if (kIsWeb) return window.localStorage.addAll(Json.cast<String, String>());
    _account = Json;
    save();
  }
}
