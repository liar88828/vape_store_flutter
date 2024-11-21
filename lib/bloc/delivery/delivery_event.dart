part of 'delivery_bloc.dart';

@immutable
sealed class DeliveryEvent {}

final class DeliveryLoadsEvent extends DeliveryEvent {}
