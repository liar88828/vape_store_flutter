part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

class OrderCalculateEvent extends OrderEvent {
  final DeliveryModel deliveryData;
  final BankModel bankData;
  final List<TrolleyModel> productTrolleyData;

  OrderCalculateEvent({
    required this.deliveryData,
    required this.bankData,
    required this.productTrolleyData,
  });
}

class OrderRemoveProductEvent extends OrderEvent {
  final int id;
  OrderRemoveProductEvent(this.id);
}

class OrderAddProductEvent extends OrderEvent {
  final List<TrolleyModel> productTrolley;
  OrderAddProductEvent(this.productTrolley);
}

class OrderAddBankEvent extends OrderEvent {
  final BankModel? bankData;
  OrderAddBankEvent({this.bankData});
}

class OrderAddDeliveryEvent extends OrderEvent {
  final DeliveryModel? deliveryData;
  OrderAddDeliveryEvent({this.deliveryData});
}

class OrderCreateCheckoutEvent extends OrderEvent {}

final class CheckoutCreateManyEvent extends OrderEvent {}

final class CheckoutCreateOneEvent extends OrderEvent {
  final int idTrolley;
  CheckoutCreateOneEvent({required this.idTrolley});
}

final class CheckoutDetailEvent extends OrderEvent {
  final int idCheckout;
  CheckoutDetailEvent({required this.idCheckout});
}

final class CheckoutLoadsEvent extends OrderEvent {}

final class CheckoutLoadEvent extends OrderEvent {}
