part of 'checkout_bloc.dart';

@immutable
sealed class CheckoutState {}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoadingState extends CheckoutState {}

final class CheckoutErrorState extends CheckoutState {
  final String message;
  CheckoutErrorState({required this.message});
}

final class CheckoutLoadsState extends CheckoutState {
  final List<CheckoutModel> checkouts;
  CheckoutLoadsState({required this.checkouts});
}

final class CheckoutLoadState extends CheckoutState {
  final CheckoutModel checkout;
  CheckoutLoadState({required this.checkout});
}
