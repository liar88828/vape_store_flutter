import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterInitial()) {
    on<IncrementCounterEvent>((event, emit) {
      emit(ChangeCounterState(counter: state.counter + 1));
    });
    on<DecrementCounterEvent>((event, emit) {
      if (state.counter > 1) {
        emit(ChangeCounterState(counter: state.counter - 1));
      }
    });
  }
}
