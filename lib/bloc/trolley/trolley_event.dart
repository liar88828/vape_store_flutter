part of 'trolley_bloc.dart';

@immutable
sealed class TrolleyEvent {}

class TrolleyCountEvent extends TrolleyEvent {}

class TrolleyLoadsEvent extends TrolleyEvent {}

class GetCheckoutEvent extends TrolleyEvent {
  final int idCheckout;
  GetCheckoutEvent({required this.idCheckout});
}

class TrolleyAddEvent extends TrolleyEvent {
  final TrolleyCreate trolley;
  TrolleyAddEvent({required this.trolley});
}

class TrolleyRemoveEvent extends TrolleyEvent {
  final int idTrolley;
  TrolleyRemoveEvent({required this.idTrolley});
}

class TrolleyChangeEvent extends TrolleyEvent {
  final TrolleyCreate trolley;
  TrolleyChangeEvent({required this.trolley});
}

class TrolleyChangeTypeEvent extends TrolleyEvent {
  final String type;
  TrolleyChangeTypeEvent({required this.type});
}

class TrolleyGetSessionEvent extends TrolleyEvent {
  TrolleyGetSessionEvent();
}
