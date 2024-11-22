part of 'delivery_bloc.dart';

@immutable
sealed class DeliveryEvent {}

final class DeliveryLoadsEvent extends DeliveryEvent {}

final class DeliverySelectEvent extends DeliveryEvent {
  final DeliveryModel? delivery;
  DeliverySelectEvent({required this.delivery});
}

// final class DeliveryRemoveEvent extends DeliveryEvent {}
