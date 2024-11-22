import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vape_store/models/response_model.dart';
import 'package:vape_store/models/trolley_model.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/network/trolley_network.dart';

part 'trolley_event.dart';
part 'trolley_state.dart';

class TrolleyBloc extends Bloc<TrolleyEvent, TrolleyState> {
  final TrolleyNetwork trolleyRepository;
  final Future<UserModel> session;
  TrolleyBloc({
    required this.trolleyRepository,
    required this.session,
  }) : super(const TrolleyInitial()) {
    on<TrolleyGetSessionEvent>((event, emit) async {
      if (state.session == null) {
        final user = await session;
        emit(TrolleySessionState(session: user));
        if (state.count == null) {
          int count = await trolleyRepository.fetchTrolleyCount(state.session!.id);
          emit(TrolleyCountState(count: count));
        }
      }
    });

    on<TrolleyCountEvent>((event, emit) async {
      emit(TrolleyLoadingState());
      try {
        final user = await session;
        int count = await trolleyRepository.fetchTrolleyCount(user.id);
        emit(TrolleyCountState(count: count));
      } catch (e) {
        emit(TrolleyErrorState(message: e.toString()));
      }
    });

    on<TrolleyLoadsEvent>((event, emit) async {
      emit(TrolleyLoadingState());
      try {
        final user = await session;
        final trolleys = await trolleyRepository.fetchTrolleyCurrent(user.id);
        emit(TrolleyLoadsState(trolleys: trolleys));
      } catch (e) {
        emit(TrolleyErrorState(message: e.toString()));
      }
    });

    on<TrolleyCheckoutEvent>((event, emit) async {
      emit(TrolleyLoadingState());
      try {
        final trolleys = await trolleyRepository.fetchTrolleyCheckout(idCheckout: event.idCheckout);
        emit(TrolleyLoadsState(trolleys: trolleys));
      } catch (e) {
        emit(TrolleyErrorState(message: e.toString()));
      }
    });

    on<TrolleyAddEvent>((event, emit) async {
      emit(TrolleyCaseLoadingState());
      try {
        final user = await session;

        final response = await trolleyRepository.addTrolley(TrolleyCreate(
          id: event.id,
          idProduct: event.idProduct,
          qty: event.qty,
          idUser: user.id,
          type: event.type,
        ));
        emit(TrolleyCaseState(response: response));
      } catch (e) {
        emit(TrolleyCaseErrorState(message: e.toString()));
      }
    });

    on<TrolleyRemoveEvent>((event, emit) async {
      emit(TrolleyCaseLoadingState());
      try {
        final response = await trolleyRepository.removeTrolley(event.idTrolley);
        emit(TrolleyCaseState(response: response));
      } catch (e) {
        emit(TrolleyCaseErrorState(message: e.toString()));
      }
    });

    on<TrolleyChangeEvent>((event, emit) async {
      emit(TrolleyCaseLoadingState());
      try {
        final response = await trolleyRepository.changeTrolley(event.trolley);
        emit(TrolleyCaseState(response: response));
      } catch (e) {
        emit(TrolleyCaseErrorState(message: e.toString()));
      }
    });

    // on<ChangeTrolleyEvent>((event, emit) async {
    //   emit(TrolleyCaseLoadingState());
    //   try {
    //     final response = await trolleyRepository.changeTrolley(event.trolley);
    //     emit(TrolleyCaseState(response: response));
    //   } catch (e) {
    //     emit(TrolleyCaseErrorState(message: e.toString()));
    //   }
    // });
  }
}
