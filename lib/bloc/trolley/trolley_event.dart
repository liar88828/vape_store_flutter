part of 'trolley_bloc.dart';

@immutable
sealed class TrolleyEvent {}

class TrolleyCountEvent extends TrolleyEvent {}

class TrolleyLoadsEvent extends TrolleyEvent {}

class TrolleyCheckoutEvent extends TrolleyEvent {
  final int idCheckout;
  TrolleyCheckoutEvent({required this.idCheckout});
}

class TrolleyAddEvent extends TrolleyEvent {
  final int id;
  final int qty;
  final int idProduct;
  final String type;

  TrolleyAddEvent({
    required this.id,
    required this.qty,
    required this.idProduct,
    required this.type,
  });
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

class TrolleySelectEvent extends TrolleyEvent {
  final bool isSelected;
  final TrolleyModel item;
  TrolleySelectEvent(this.isSelected, this.item);
}

class TrolleyIncrementEvent extends TrolleyEvent {
  final TrolleyModel item;
  TrolleyIncrementEvent(this.item);
}

class TrolleyDecrementEvent extends TrolleyEvent {
  final TrolleyModel item;
  TrolleyDecrementEvent(this.item);
}

class TrolleyGoCheckoutScreenStateEvent extends TrolleyEvent {}
