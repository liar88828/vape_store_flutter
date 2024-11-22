part of 'order_bloc.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}

class OrderUpdated extends OrderState {
  final OrderInfoModel orderInfo;

  OrderUpdated(this.orderInfo);
}
