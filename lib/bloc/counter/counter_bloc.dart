import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterInitial()) {
    on<IncrementCounterEvent>((event, emit) {
      emit(ChangeCounterState(counter: state.counter + 1));
    });
    on<DecrementCounterEvent>((event, emit) {
      emit(ChangeCounterState(counter: state.counter - 1));
    });
  }
}
