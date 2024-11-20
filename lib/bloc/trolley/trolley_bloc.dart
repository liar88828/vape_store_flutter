import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vape_store/models/response_model.dart';
import 'package:vape_store/models/trolley_model.dart';
import 'package:vape_store/network/trolley_network.dart';
import 'package:vape_store/repository/preferences_repo.dart';

part 'trolley_event.dart';
part 'trolley_state.dart';

class TrolleyBloc extends Bloc<TrolleyEvent, TrolleyState> {
  final TrolleyNetwork trolleyRepository;
  final PreferencesRepository preferencesRepository;
  // final UserModel? userSession;
  TrolleyBloc(
      {required this.trolleyRepository,
      // required this.userSession,
      required this.preferencesRepository
      // required int count,
      })
      : super(const TrolleyInitial(count: 0)) {
    on<GetCountEvent>((event, emit) async {
      emit(TrolleyLoadingState());
      try {
        final userSession = await preferencesRepository.getUser();
        int count = await trolleyRepository.fetchTrolleyCount(userSession.id);
        emit(TrolleyCountState(count: count));
      } catch (e) {
        emit(const TrolleyCountState(count: 0));
      }
    });

    on<GetTrolleyEvent>((event, emit) async {
      emit(TrolleyLoadingState());
      try {
        final userSession = await preferencesRepository.getUser();
        final trolleys = await trolleyRepository.fetchTrolleyCurrent(userSession.id);
        emit(TrolleyLoadState(trolleys: trolleys));
      } catch (e) {
        emit(TrolleyErrorState(message: e.toString()));
      }
    });

    on<GetCheckoutEvent>((event, emit) async {
      emit(TrolleyLoadingState());
      try {
        final trolleys = await trolleyRepository.fetchTrolleyCheckout(event.idCheckout);
        emit(TrolleyLoadState(trolleys: trolleys));
      } catch (e) {
        emit(TrolleyErrorState(message: e.toString()));
      }
    });

    on<AddTrolleyEvent>((event, emit) async {
      emit(TrolleyCaseLoadingState());
      try {
        final response = await trolleyRepository.addTrolley(event.trolley);
        emit(TrolleyCaseState(response: response));
      } catch (e) {
        emit(TrolleyCaseErrorState(message: e.toString()));
      }
    });

    on<RemoveTrolleyEvent>((event, emit) async {
      emit(TrolleyCaseLoadingState());
      try {
        final response = await trolleyRepository.removeTrolley(event.idTrolley);
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

    on<ChangeTrolleyEvent>((event, emit) async {
      emit(TrolleyCaseLoadingState());
      try {
        final response = await trolleyRepository.changeTrolley(event.trolley);
        emit(TrolleyCaseState(response: response));
      } catch (e) {
        emit(TrolleyCaseErrorState(message: e.toString()));
      }
    });
  }
}
