import 'dart:io';

import 'package:blocsync_server/blocsync_server.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:uuid/uuid.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _onPost(RequestContext context, String id) async {
  final userId = context.read<UserId>();
  final storage = context.read<StateStorage>();
  final sessionId = const Uuid().v4();
  await storage.put(
    'live_session:$sessionId',
    {
      'id': id,
      'userId': userId,
      'ip_address': context.request.headers['x-forwarded-for'],
    },
    ttl: const Duration(seconds: 2),
  );
  return Response.json(
    body: {
      'sessionId': sessionId,
    },
  );
}
