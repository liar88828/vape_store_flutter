part of 'checkout_bloc.dart';

@immutable
sealed class CheckoutEvent {}

final class CheckoutLoadsEvent extends CheckoutEvent {}

final class CheckoutLoadEvent extends CheckoutEvent {}

final class CheckoutCreateManyEvent extends CheckoutEvent {
  final CheckoutModel checkout;
  final List<int> idTrolley;
  CheckoutCreateManyEvent({required this.checkout, required this.idTrolley});
}

final class CheckoutCreateOneEvent extends CheckoutEvent {
  final CheckoutModel checkout;
  final int idTrolley;
  CheckoutCreateOneEvent({required this.checkout, required this.idTrolley});
}

final class CheckoutDetailEvent extends CheckoutEvent {
  final int idCheckout;
  CheckoutDetailEvent({required this.idCheckout});
}
