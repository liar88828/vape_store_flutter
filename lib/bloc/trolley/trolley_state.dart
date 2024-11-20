part of 'trolley_bloc.dart';

@immutable
sealed class TrolleyState {
  final int? count;
  final List<TrolleyModel>? trolleys;

  const TrolleyState({this.count, this.trolleys});
}

final class TrolleyInitial extends TrolleyState {
  const TrolleyInitial({required super.count});
}

final class TrolleyCountState extends TrolleyState {
  const TrolleyCountState({required super.count});
}

final class TrolleyLoadState extends TrolleyState {
  const TrolleyLoadState({required super.trolleys});
}

final class TrolleyLoadingState extends TrolleyState {}

final class TrolleyErrorState extends TrolleyState {
  final String message;
  const TrolleyErrorState({required this.message});
}

final class TrolleyCaseState extends TrolleyState {
  final ResponseModel response;
  const TrolleyCaseState({required this.response});
}

final class TrolleyCaseLoadingState extends TrolleyState {}

final class TrolleyCaseErrorState extends TrolleyState {
  final String message;
  const TrolleyCaseErrorState({required this.message});
}

final class TrolleyTypeState extends TrolleyState {
  final String type;
  const TrolleyTypeState({required this.type});
}
