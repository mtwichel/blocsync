import 'dart:convert';
import 'dart:io';

import 'package:blocsync_server/blocsync_server.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

final Map<String, Set<WebSocketChannel>> _channels = {};
Future<Response> onRequest(RequestContext context, String sessionId) async {
  final storage = context.read<StateStorage>();
  final session = await storage.get('live_session:$sessionId');
  if (session == null) {
    return Response(statusCode: HttpStatus.notFound);
  }
  final userId = session['userId'];
  final ipAddress = session['ip_address'];
  final id = session['id'];

  if (userId is! String? || id is! String) {
    return Response(statusCode: HttpStatus.notFound);
  }

  if (ipAddress != context.request.headers['x-forwarded-for']) {
    return Response(statusCode: HttpStatus.forbidden);
  }

  await storage.delete('live_session:$sessionId');

  final handler = webSocketHandler((channel, protocol) {
    _channels.putIfAbsent(id, () => {}).add(channel);
    channel.stream.listen((message) async {
      if (message is! String) {
        return;
      }
      final decoded = Map<String, dynamic>.from(jsonDecode(message) as Map);
      final event = decoded['event'] as Map<String, dynamic>?;
      final state = decoded['state'] as Map<String, dynamic>?;
      if (event != null) {
        for (final otherChannel in _channels[id]!) {
          if (otherChannel == channel) {
            continue;
          }
          otherChannel.sink.add(message);
        }
      }
      if (state != null) {
        if (userId == null) {
          await storage.put(id, state);
        } else {
          await storage.put('$userId:$id', state);
        }
      }
    });
  });
  return handler(context);
}
