import 'package:blocsync/src/live_mixin.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

abstract class LiveBloc<Event extends LiveEvent, State>
    extends Bloc<Event, State>
    with HydratedMixin<State>, LiveMixin<Event, State> {
  LiveBloc(super.initialState) {
    hydrate();
    startListening();
  }
}
