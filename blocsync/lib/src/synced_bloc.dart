import 'package:blocsync/src/synced_mixin.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

abstract class SyncedBloc<Event, State> extends Bloc<Event, State>
    with HydratedMixin<State>, SyncedMixin<State> {
  SyncedBloc(super.initialState) {
    hydrate();
    startSyncing();
  }
}

abstract class SyncedCubit<State> extends Cubit<State>
    with HydratedMixin<State>, SyncedMixin<State> {
  SyncedCubit(super.initialState) {
    hydrate();
    startSyncing();
  }
}
