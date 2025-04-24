import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

//Events

sealed class CounterEvent{}

final class IncrementCounter extends CounterEvent{}

final class ResetCounter extends CounterEvent{}

// States

class CounterState extends Equatable{
  final int count;
  const CounterState(this.count);

  @override
  List<Object?> get props => [count];
}

//Bloc

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0)) {
    on<IncrementCounter>((event, emit) => emit(CounterState(state.count + 1)));
    on<ResetCounter>((event, emit) => emit(const CounterState(0)));
  }
}