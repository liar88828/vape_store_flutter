part of 'counter_bloc.dart';

sealed class CounterState {
  int counter;
  CounterState({this.counter = 1});
}

final class CounterInitial extends CounterState {}

final class ChangeCounterState extends CounterState {
  ChangeCounterState({required super.counter});
}
