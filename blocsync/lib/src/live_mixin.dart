import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:blocsync/blocsync.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_client/web_socket_client.dart';

mixin LiveEvent {
  String id = Uuid().v4();
}

mixin LiveMixin<Event extends LiveEvent, State> on Bloc<Event, State> {
  late StreamSubscription<dynamic> subscription;
  late WebSocket socket;

  Future<void> startListening() async {
    socket = await BlocSyncConfig.apiClient.subscribe(
      storageToken,
      isPrivate: isPrivate,
    );
    final json = await BlocSyncConfig.apiClient.fetch(
      storageToken,
      isPrivate: isPrivate,
    );
    print(json);
    if (json == null) {
      return;
    }
    final state = fromJson(json);
    if (state == null) {
      return;
    }
    // ignore: invalid_use_of_visible_for_testing_member
    emit(state);

    subscription = socket.messages.listen((message) {
      if (message is! String) {
        return;
      }
      _onMessage(message);
    });
  }

  @override
  Future<void> close() async {
    await subscription.cancel();
    socket.close();
    super.close();
  }

  @override
  void onEvent(Event event) {
    super.onEvent(event);
    if (_messageIds.contains(event.id)) {
      return;
    }
    socket.send(jsonEncode({'event': eventToJson(event), 'id': event.id}));
  }

  @override
  void onChange(Change<State> change) {
    super.onChange(change);
    socket.send(jsonEncode({'state': toJson(change.nextState)}));
  }

  Future<void> _onMessage(String message) async {
    final json = jsonDecode(message);
    final parsed = Map<String, dynamic>.from(json as Map);
    final eventId = parsed['id'] as String;
    _messageIds.add(eventId);
    final event = eventFromJson(parsed['event'] as Map<String, dynamic>);
    if (event == null) {
      return;
    }

    event.id = eventId;

    add(event);
  }

  final Set<String> _messageIds = {};

  Event? eventFromJson(Map<String, dynamic> json);
  Map<String, dynamic>? eventToJson(Event event);
  Map<String, dynamic>? toJson(State state);
  State fromJson(Map<String, dynamic> json);

  bool get isPrivate => false;

  String get id => '';

  String get storagePrefix => runtimeType.toString();

  String get storageToken => '$storagePrefix$id';
}
