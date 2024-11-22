part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

class CalculateOrderInfo extends OrderEvent {
  final DeliveryModel deliveryData;
  final BankModel bankData;
  final List<TrolleyModel> trolley;

  CalculateOrderInfo({
    required this.deliveryData,
    required this.bankData,
    required this.trolley,
  });
}

class RemoveTrolleyItem extends OrderEvent {
  final int id;

  RemoveTrolleyItem(this.id);
}
