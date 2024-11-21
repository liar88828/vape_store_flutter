part of 'trolley_bloc.dart';

@immutable
sealed class TrolleyState {
  final UserModel? session;
  final int? count;
  final List<TrolleyModel>? trolleys;

  const TrolleyState({this.count, this.trolleys, this.session});
}

final class TrolleyInitial extends TrolleyState {
  const TrolleyInitial({
    super.count,
    super.session,
  });
}

final class TrolleyLoadingState extends TrolleyState {}

final class TrolleyErrorState extends TrolleyState {
  final String message;
  const TrolleyErrorState({required this.message});
}

final class TrolleyCountState extends TrolleyState {
  const TrolleyCountState({required super.count});
}

final class TrolleySessionState extends TrolleyState {
  const TrolleySessionState({required super.session});
}

final class TrolleyLoadState extends TrolleyState {
  @override
  final List<TrolleyModel> trolleys;
  const TrolleyLoadState({required this.trolleys}) : super(trolleys: trolleys);
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
