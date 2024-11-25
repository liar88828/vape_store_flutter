part of 'order_bloc.dart';

@immutable
sealed class OrderState {
  final DeliveryModel? deliveryData;
  final BankModel? bankData;
  final List<TrolleyModel> productTrolleyData;
  final OrderInfoModel? totalAll;
  final CheckoutModel? checkout;

  const OrderState({
    this.checkout,
    this.bankData,
    this.deliveryData,
    this.productTrolleyData = const [],
    this.totalAll,
  });
}

final class OrderInitial extends OrderState {
  const OrderInitial({
    super.bankData,
    super.deliveryData,
    super.productTrolleyData,
    super.totalAll,
  });
}

class OrderUpdated extends OrderState {
  final OrderInfoModel orderInfo;
  const OrderUpdated(this.orderInfo);
}

class OrderLoadingState extends OrderState {}

class OrderErrorState extends OrderState {}

final class CheckoutErrorState extends OrderState {
  final String message;
  CheckoutErrorState({required this.message});
}

final class CheckoutLoadsState extends OrderState {
  final List<CheckoutModel> checkouts;
  CheckoutLoadsState({required this.checkouts});
}

final class CheckoutLoadState extends OrderState {
  final CheckoutModel checkout;
  CheckoutLoadState({required this.checkout});
}

final class CheckoutLoadingState extends OrderState {}

final class CheckoutInitial extends OrderState {}
