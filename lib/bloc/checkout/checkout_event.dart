part of 'checkout_bloc.dart';

@immutable
sealed class CheckoutEvent {}

final class CheckoutLoadsEvent extends CheckoutEvent {}

final class CheckoutLoadEvent extends CheckoutEvent {}
