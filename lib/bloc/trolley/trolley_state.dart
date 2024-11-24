part of 'trolley_bloc.dart';

@immutable
sealed class TrolleyState {
  final UserModel? session;
  final int? count;
  final List<TrolleyModel> trolleys;
  final List<TrolleyModel> cartItems;
  final num totalPrice;
  const TrolleyState({
    this.count,
    this.session,
    this.trolleys = const [],
    this.cartItems = const [],
    this.totalPrice = 0,
  });
}

final class TrolleyInitial extends TrolleyState {
  const TrolleyInitial({
    super.count,
    super.session,
    super.cartItems,
    super.totalPrice,
    super.trolleys,
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

final class TrolleyLoadsState extends TrolleyState {
  @override
  final List<TrolleyModel> trolleys;
  const TrolleyLoadsState({required this.trolleys}) : super(trolleys: trolleys);
}

final class TrolleyCaseState extends TrolleyState {
  final ResponseModel response;
  const TrolleyCaseState({required this.response});
}

final class TrolleyRemoveState extends TrolleyState {
  final String message;
  const TrolleyRemoveState({required this.message});
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

final class TrolleySelectState extends TrolleyState {
  @override
  final List<TrolleyModel> cartItems;
  // final String select;
  const TrolleySelectState({required this.cartItems}) : super(cartItems: cartItems);
}

final class TrolleyCalculateInitials extends TrolleyState {
  const TrolleyCalculateInitials({super.cartItems, super.trolleys, super.totalPrice});
}
