// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors, unnecessary_new, camel_case_types, annotate_overrides, prefer_const_literals_to_create_immutables, prefer_equal_for_default_values, unused_element
/*
The code here is referenced from https://codelabs.developers.google.com/codelabs/flutter-MS-graphql-client
 */

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rpmtranslator/Utility/utility.dart';
import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:rpmtranslator/Account/Account.dart';
import 'package:rpmtranslator/Account/CrowdinAuth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

final _authorizationEndpoint =
    Uri.parse('https://accounts.crowdin.com/oauth/authorize');
final _tokenEndpoint = Uri.parse('https://accounts.crowdin.com/oauth/token');

class CrowdinAuthScreen extends StatefulWidget {
  const CrowdinAuthScreen({Key? key}) : super(key: key);

  @override
  _CrowdinOauthState createState() => _CrowdinOauthState();
}

typedef AuthenticatedBuilder = Widget Function(
    BuildContext context, oauth2.Client client);

class _CrowdinOauthState extends State<CrowdinAuthScreen> {
  HttpServer? _redirectServer;
  oauth2.Client? _client;

  @override
  Widget build(BuildContext context) {
    final client = _client;
    if (client != null) {
      return FutureBuilder(
          future: CrowdinAuthHandler.CheckToken(client.credentials.accessToken),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData &&
                snapshot.data[0] == CrowdinAuthHandler.Success) {
              Account.add(
                  client.credentials.accessToken,
                  client.credentials.refreshToken.toString(),
                  snapshot.data[1]['data']['id']);
              return AlertDialog(
                title: Text("????????????", textAlign: TextAlign.center),
                actions: [
                  IconButton(
                    icon: Icon(Icons.close),
                    tooltip: "??????",
                    onPressed: () {
                      Navigator.pushNamed(context, HomePage.route);
                    },
                  )
                ],
              );
            } else if (snapshot.hasData &&
                snapshot.data[0] == CrowdinAuthHandler.Error) {
              return AlertDialog(
                title: Text("????????????", textAlign: TextAlign.center),
                content: Text("???????????????????????????????????????????????????????????????????????? RPMTW Discord ??????????????????",
                    textAlign: TextAlign.center),
                actions: [
                  IconButton(
                    icon: Icon(Icons.refresh),
                    tooltip: "????????????",
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      utility.IsWebAccount(context);
                    },
                  )
                ],
              );
            } else {
              return AlertDialog(
                title: Text("???????????????????????????...", textAlign: TextAlign.center),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              );
            }
          });
    }
    if (Account.has() && !Account.expired()) {
      //????????????????????????????????????????????????
      return AlertDialog(
        title: Text("???????????????????????????"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("???????????????")),
          TextButton(
              onPressed: () {
                Account.logout();
                Navigator.pop(context);
              },
              child: Text("????????????"))
        ],
      );
    } else {
      return Center(
          child: AlertDialog(
        title: Text("???????????? Crowdin ?????? ", textAlign: TextAlign.center),
        content: Text(
          "??????????????? ?????? ??????????????????????????????????????????????????????????????? Crowdin ??????",
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 20),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await _redirectServer?.close();
                _redirectServer = await HttpServer.bind('127.0.0.1', 5000);
                var authenticatedHttpClient = await _getOAuth2Client(Uri.parse(
                    'http://127.0.0.1:${_redirectServer!.port}/rpmtranslator-auth'));
                setState(() {
                  _client = authenticatedHttpClient;
                });
              },
              child: Text("??????"),
            ),
          )
        ],
      ));
    }
  }

  Future<oauth2.Client> _getOAuth2Client(Uri redirectUrl) async {
    var grant = oauth2.AuthorizationCodeGrant(
      "hxk05Ij1xVFDEemvb2Ra", //Client ID
      _authorizationEndpoint,
      _tokenEndpoint,
      secret: 'l6maTnuFjLwqx9nDAbCiB42CHTzqyJnPko9qzRrv',
      httpClient: _JsonAcceptingHttpClient(),
    );
    var authorizationUrl =
        grant.getAuthorizationUrl(redirectUrl, scopes: ['project']);
    await _redirect(authorizationUrl);
    Map<String, String> responseQueryParameters = await _listen();
    oauth2.Client client =
        await grant.handleAuthorizationResponse(responseQueryParameters);
    return client;
  }

  Future<void> _redirect(authorizationUrl) async {
    var url = authorizationUrl.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Can't open the url $url");
    }
  }

  Future<Map<String, String>> _listen() async {
    var request = await _redirectServer!.first;
    var params = request.uri.queryParameters;
    request.response.statusCode = 200;
    request.response.headers.set('content-type', 'text/plain; charset=utf-8');
    request.response.writeln('???????????????????????? RPMTranslator ??????');
    await request.response.close();
    await _redirectServer!.close();
    _redirectServer = null;
    return params;
  }
}

class _JsonAcceptingHttpClient extends http.BaseClient {
  final _httpClient = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return _httpClient.send(request);
  }
}
