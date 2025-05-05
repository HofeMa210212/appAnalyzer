import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class SpotifyAuth {
  static final SpotifyAuth _instance = SpotifyAuth._internal();

  factory SpotifyAuth() => _instance;

  SpotifyAuth._internal();

  final String _clientId = '5d2c98b9d4694c18a58446102a524fa5';
  final String _clientSecret = '6857286bc82445428ea817a0a37dff3d';

  String? _accessToken;
  Timer? _refreshTimer;

  Future<void> fetchAccessToken() async {
    final credentials = base64.encode(utf8.encode('$_clientId:$_clientSecret'));

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _accessToken = data['access_token'];
      final expiresIn = data['expires_in'];

      print('Access Token: $_accessToken');

      _refreshTimer?.cancel();
      _refreshTimer = Timer(Duration(seconds: expiresIn - 300), fetchAccessToken);
    } else {
      print('Fehler beim Token holen: ${response.body}');
    }
  }

  Future<void> logInUser()async{
    final codeVerifier = generateCodeVerifier();
    final codeChallenge = generateCodeChallenge(codeVerifier);

    final authUrl = 'https://accounts.spotify.com/authorize'
        '?client_id=5d2c98b9d4694c18a58446102a524fa5'
        '&response_type=code'
        '&redirect_uri=myapp://callback'
        '&scope=user-read-private user-read-email user-top-read user-read-recently-played'
        '&code_challenge_method=S256'
        '&code_challenge=$codeChallenge';

    final result = await FlutterWebAuth2.authenticate(
      url: authUrl,
      callbackUrlScheme: "myapp",
    );

    final code = Uri.parse(result).queryParameters['code'];
    print(code);

  }

  String generateCodeVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(64, (i) => random.nextInt(256));
    return base64UrlEncode(values).replaceAll('=', '');
  }

  String generateCodeChallenge(String codeVerifier) {
    final bytes = utf8.encode(codeVerifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }


  String? get accessToken => _accessToken;

  void dispose() {
    _refreshTimer?.cancel();
  }
}
