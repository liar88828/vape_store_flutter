part of 'trolley_bloc.dart';

@immutable
sealed class TrolleyEvent {}

class GetCountEvent extends TrolleyEvent {}

class GetTrolleyEvent extends TrolleyEvent {}

class GetCheckoutEvent extends TrolleyEvent {
  final int idCheckout;
  GetCheckoutEvent({required this.idCheckout});
}

class AddTrolleyEvent extends TrolleyEvent {
  final TrolleyCreate trolley;
  AddTrolleyEvent({required this.trolley});
}

class RemoveTrolleyEvent extends TrolleyEvent {
  final int idTrolley;
  RemoveTrolleyEvent({required this.idTrolley});
}

class ChangeTrolleyEvent extends TrolleyEvent {
  final TrolleyCreate trolley;
  ChangeTrolleyEvent({required this.trolley});
}

class ChangeTypeEvent extends TrolleyEvent {
  final String type;
  ChangeTypeEvent({required this.type});
}
