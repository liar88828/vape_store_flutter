import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vape_store/models/checkout_model.dart';
import 'package:vape_store/models/response_model.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/network/checkout_network.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutNetwork checkoutRepository;
  final Future<UserModel> session;
  CheckoutBloc({
    required this.checkoutRepository,
    required this.session,
  }) : super(CheckoutInitial()) {
    on<CheckoutLoadsEvent>((event, emit) async {
      emit(CheckoutLoadingState());
      try {
        final user = await session;
        final checkouts = await checkoutRepository.fetchAll(user.id);
        emit(CheckoutLoadsState(checkouts: checkouts));
      } catch (e) {
        CheckoutErrorState(message: e.toString());
      }
    });

    on<CheckoutCreateManyEvent>((event, emit) async {
      emit(CheckoutLoadingState());
      try {
        final user = await session;
        final ResponseModel<CheckoutModel> response = await checkoutRepository.createManyCheckout(
          checkout: event.checkout,
          idTrolley: event.idTrolley,
          user: user,
        );
        emit(CheckoutLoadState(checkout: response.data!));
      } catch (e) {
        CheckoutErrorState(message: e.toString());
      }
    });

    on<CheckoutCreateOneEvent>((event, emit) async {
      emit(CheckoutLoadingState());
      try {
        final user = await session;
        final ResponseModel response = await checkoutRepository.createSingleCheckout(
          checkout: event.checkout,
          idTrolley: event.idTrolley,
          user: user,
        );
        // emit(CheckoutLoadState(checkout: response.data!));
      } catch (e) {
        CheckoutErrorState(message: e.toString());
      }
    });

    on<CheckoutDetailEvent>((event, emit) async {
      emit(CheckoutLoadingState());
      try {
        final user = await session;
        final checkouts = await checkoutRepository.fetchId(idCheckout: user.id);
        emit(CheckoutLoadState(checkout: checkouts));
      } catch (e) {
        CheckoutErrorState(message: e.toString());
      }
    });
  }
}
