part of 'delivery_bloc.dart';

@immutable
sealed class DeliveryState {}

final class DeliveryInitial extends DeliveryState {}

final class DeliveryLoadingState extends DeliveryState {}

final class DeliveryLoadsState extends DeliveryState {
  final List<DeliveryModel> deliveryList;
  DeliveryLoadsState({required this.deliveryList});
}

final class DeliveryErrorState extends DeliveryState {
  final String message;
  DeliveryErrorState({required this.message});
}
