import 'package:blocsync/blocsync.dart';

class CounterBloc extends LiveBloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
    on<Decrement>((event, emit) => emit(state - 1));
  }

  @override
  bool get isPrivate => false;

  @override
  int fromJson(Map<String, dynamic> json) => json['value'] as int;

  @override
  Map<String, dynamic>? toJson(int state) => {'value': state};

  @override
  CounterEvent? eventFromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'increment':
        return Increment();
      case 'decrement':
        return Decrement();
    }
    return null;
  }

  @override
  Map<String, dynamic>? eventToJson(CounterEvent event) {
    switch (event) {
      case Increment():
        return {'type': 'increment'};
      case Decrement():
        return {'type': 'decrement'};
    }
    return null;
  }
}

abstract class CounterEvent with LiveEvent {}

class Increment extends CounterEvent {}

class Decrement extends CounterEvent {}
