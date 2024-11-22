import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vape_store/models/delivery_model.dart';
import 'package:vape_store/network/delivery_network.dart';

part 'delivery_event.dart';
part 'delivery_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final DeliveryNetwork deliveryRepository;
  DeliveryBloc({required this.deliveryRepository}) : super(DeliveryInitial()) {
    on<DeliveryLoadsEvent>((event, emit) async {
      emit(DeliveryLoadingState());
      try {
        final data = await deliveryRepository.fetchDelivery();
        emit(DeliveryLoadsState(deliverys: data));
      } catch (e) {
        emit(DeliveryErrorState(message: e.toString()));
      }
    });

    on<DeliverySelectEvent>((event, emit) {
      emit(DeliverySelectState(delivery: event.delivery));
    });
  }
}
