import 'package:bloc/bloc.dart';
import 'package:blocsync/src/blocsync_config.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

mixin SyncedMixin<State> on BlocBase<State> {
  Future<void> startSyncing() async {
    final json = await BlocSyncConfig.apiClient.fetch(
      storageToken,
      isPrivate: isPrivate,
    );
    if (json == null) {
      return;
    }
    final state = fromJson(json);
    if (state == null) {
      return;
    }
    emit(state);
  }

  @override
  Future<void> onChange(Change<State> change) async {
    super.onChange(change);

    final stateJson = toJson(change.nextState);
    if (stateJson != null) {
      await BlocSyncConfig.apiClient.save(
        storageToken,
        data: stateJson,
        isPrivate: isPrivate,
      );
    }
  }

  String get id => '';

  String get storagePrefix => runtimeType.toString();

  String get storageToken => '$storagePrefix$id';

  bool get isPrivate => false;

  State? fromJson(Map<String, dynamic> json);

  Map<String, dynamic>? toJson(State state);
}
