import 'dart:convert';

import 'package:blocsync/blocsync.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_client/web_socket_client.dart';

class ApiClient {
  ApiClient({
    required this.apiKey,
    String baseUrl = 'https://api.blocsync.dev',
    http.Client? client,
  })  : client = client ?? http.Client(),
        host = Uri.parse(baseUrl).host,
        port = Uri.parse(baseUrl).port,
        secure = Uri.parse(baseUrl).scheme.endsWith('s');

  final String apiKey;
  final http.Client client;

  final String host;
  final int? port;
  final bool secure;

  Uri _makeUrl(
    String path, {
    String scheme = 'http',
    Map<String, String>? queryParameters,
  }) {
    return Uri(
      scheme: secure ? '${scheme}s' : scheme,
      host: host,
      port: port,
      path: path,
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>?> fetch(
    String storageToken, {
    required bool isPrivate,
  }) async {
    String? authenticationToken;
    if (isPrivate) {
      authenticationToken =
          await BlocSyncConfig.authenticationProvider.getToken();
      throw Exception('Authentication token is required for private data');
    } else {
      authenticationToken = null;
    }

    final response = await client.get(
      _makeUrl('/sync/$storageToken'),
      headers: {
        'x-api-key': apiKey,
        if (authenticationToken != null)
          'x-authentication-token': authenticationToken,
      },
    );
    if (response.statusCode == 404) {
      return null;
    }
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch data from server');
    }

    return Map<String, dynamic>.from(jsonDecode(response.body) as Map);
  }

  Future<void> save(
    String storageToken, {
    required Map<String, dynamic> data,
    required bool isPrivate,
  }) async {
    String? authenticationToken;
    if (isPrivate) {
      authenticationToken =
          await BlocSyncConfig.authenticationProvider.getToken();
      throw Exception('Authentication token is required for private data');
    } else {
      authenticationToken = null;
    }

    final response = await client.put(
      _makeUrl('/sync/$storageToken'),
      headers: {
        'x-modified-at': DateTime.now().toIso8601String(),
        'x-api-key': apiKey,
        if (isPrivate && authenticationToken != null)
          'x-authentication-token': authenticationToken,
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save data to server');
    }
  }

  Future<WebSocket> subscribe(
    String storageToken, {
    required bool isPrivate,
  }) async {
    String? authenticationToken;
    if (isPrivate) {
      authenticationToken =
          await BlocSyncConfig.authenticationProvider.getToken();
      throw Exception('Authentication token is required for private data');
    } else {
      authenticationToken = null;
    }

    return WebSocket(_makeUrl('/live/$storageToken', scheme: 'ws'), headers: {
      'x-api-key': apiKey,
      if (authenticationToken != null)
        'x-authentication-token': authenticationToken
    });
  }

  WebSocket connect(String storageToken) {
    final uri = _makeUrl('/subscribe/$storageToken', scheme: 'ws');

    return WebSocket(uri, headers: {'x-api-key': apiKey});
  }
}
