// ignore_for_file: overridden_fields

part of 'delivery_bloc.dart';

@immutable
sealed class DeliveryState {
  final DeliveryModel? delivery;
  final List<DeliveryModel>? deliveryList;
  const DeliveryState({this.delivery, this.deliveryList});
}

final class DeliveryInitial extends DeliveryState {}

final class DeliveryLoadingState extends DeliveryState {}

final class DeliveryLoadsState extends DeliveryState {
  final List<DeliveryModel> deliverys;
  const DeliveryLoadsState({required this.deliverys}) : super(deliveryList: deliverys);
}

final class DeliveryErrorState extends DeliveryState {
  final String message;
  const DeliveryErrorState({required this.message});
}

final class DeliverySelectState extends DeliveryState {
  @override
  final DeliveryModel? delivery;
  const DeliverySelectState({required this.delivery}) : super(delivery: delivery);
}
