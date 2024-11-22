part of 'delivery_bloc.dart';

@immutable
sealed class DeliveryState {
  final DeliveryModel? delivery;
  const DeliveryState({this.delivery});
}

final class DeliveryInitial extends DeliveryState {}

final class DeliveryLoadingState extends DeliveryState {}

final class DeliveryLoadsState extends DeliveryState {
  final List<DeliveryModel> deliverys;
  const DeliveryLoadsState({required this.deliverys});
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
