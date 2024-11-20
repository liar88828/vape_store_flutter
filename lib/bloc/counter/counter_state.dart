part of 'counter_bloc.dart';

sealed class CounterState {
  int counter;
  CounterState({this.counter = 0});
}

final class CounterInitial extends CounterState {}

final class ChangeCounterState extends CounterState {
  @override
  final int counter;
  ChangeCounterState({required this.counter}) : super(counter: counter);
}
