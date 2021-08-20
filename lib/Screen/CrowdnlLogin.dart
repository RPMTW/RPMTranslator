// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names, avoid_print, prefer_const_constructors

/*
The code here is referenced from https://codelabs.developers.google.com/codelabs/flutter-MS-graphql-client
 */

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';

final _authorizationEndpoint =
    Uri.parse('https://login.live.com/oauth20_authorize.srf');
final _tokenEndpoint = Uri.parse('https://login.live.com/oauth20_token.srf');

class MSLoginWidget extends StatefulWidget {
  const MSLoginWidget({
    required this.builder,
  });

  final AuthenticatedBuilder builder;

  @override
  _MSLoginState createState() => _MSLoginState();
}

typedef AuthenticatedBuilder = Widget Function(
    BuildContext context, oauth2.Client client);

class _MSLoginState extends State<MSLoginWidget> {
  HttpServer? _redirectServer;
  oauth2.Client? _client;

  @override
  Widget build(BuildContext context) {
    final client = _client;
    if (client != null) {
      return widget.builder(context, client);
    }
    return Center(
        child: AlertDialog(
      title: Text("提示訊息 - 登入您的 Microsoft 帳號 ", textAlign: TextAlign.center),
      content: Text(
        "",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () async {
              await _redirectServer?.close();
              _redirectServer = await HttpServer.bind('localhost', 0);
              var authenticatedHttpClient = await _getOAuth2Client(Uri.parse(
                  'http://localhost:${_redirectServer!.port}/rpmlauncher-auth'));
              setState(() {
                _client = authenticatedHttpClient;
              });

              // showDialog(
              //     context: context,
              //     builder: (context) {
              //       return AlertDialog(
              //         title: Text("處理中..."),
              //         content: Text("test"),
              //       );
              //     });
            },
            child: Text('OK'),
          ),
        )
      ],
    ));
  }

  Future<oauth2.Client> _getOAuth2Client(Uri redirectUrl) async {
    var grant = oauth2.AuthorizationCodeGrant(
      "b7df55b4-300f-4409-8ea9-a172f844aa15", //Client ID
      _authorizationEndpoint,
      _tokenEndpoint,
      httpClient: _JsonAcceptingHttpClient(),
    );
    var authorizationUrl = grant.getAuthorizationUrl(redirectUrl,
        scopes: ['XboxLive.signin', 'offline_access']);
    authorizationUrl = Uri.parse(
        "${authorizationUrl.toString()}&cobrandid=8058f65d-ce06-4c30-9559-473c9275a65d");
    await _redirect(authorizationUrl);
    var responseQueryParameters = await _listen();
    var client =
        await grant.handleAuthorizationResponse(responseQueryParameters);
    // await MSAccountHandler().AuthorizationXBL(client.credentials.accessToken);
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
    request.response.headers.set('content-type', 'text/plain');
    request.response.writeln('Authenticated! You can close this tab.');
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
