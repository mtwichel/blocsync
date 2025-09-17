import 'dart:io';

import 'package:blocsync_server/blocsync_server.dart';
import 'package:dart_frog/dart_frog.dart';

import '../main.dart';

/// CORS middleware to handle cross-origin requests from localhost
Middleware corsMiddleware() {
  return (handler) {
    return (context) async {
      final request = context.request;
      final origin = request.headers['origin'];

      // Handle preflight requests
      if (request.method == HttpMethod.options) {
        return Response(
          headers: {
            'Access-Control-Allow-Origin': origin ?? '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers':
                'Content-Type, Authorization, X-API-Key',
            'Access-Control-Max-Age': '86400',
          },
        );
      }

      // Process the request
      final response = await handler(context);

      // Add CORS headers to the response
      final headers = Map<String, String>.from(response.headers);
      headers['Access-Control-Allow-Origin'] = origin ?? '*';
      headers['Access-Control-Allow-Methods'] =
          'GET, POST, PUT, DELETE, OPTIONS';
      headers['Access-Control-Allow-Headers'] =
          'Content-Type, Authorization, X-API-Key';

      return response.copyWith(headers: headers);
    };
  };
}

Handler middleware(Handler handler) {
  final authenticationEnabled =
      Platform.environment['AUTHENTICATION_ENABLED'] == 'true';
  var newHandler = handler
      .use(corsMiddleware())
      .use(requestLogger())
      .use(apiKeyMiddleware())
      .use(provider<StateStorage>((_) => storage));
  if (authenticationEnabled) {
    newHandler = newHandler.use(jwtMiddleware());
  } else {
    newHandler = newHandler.use(provider<UserId>((_) => null));
  }

  return newHandler;
}
