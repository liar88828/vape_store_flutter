import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vape_store/models/bank_model.dart';
import 'package:vape_store/network/bank_network.dart';

part 'bank_event.dart';
part 'bank_state.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  final BankNetwork bankRepository;
  BankBloc({required this.bankRepository}) : super(BankInitial()) {
    on<BankLoadsEvent>((event, emit) async {
      emit(BankLoadingState());
      try {
        if (state.banks.isEmpty) {
          final data = await bankRepository.fetchBanks();
          emit(BankLoadsState(banks: data));
        } else {
          emit(BankLoadsState(banks: state.banks));
        }
      } catch (e) {
        emit(BankErrorState(message: e.toString()));
      }
    });

    on<BankSelectEvent>((event, emit) {
      emit(BankSelectState(bank: event.bank));
    });
  }
}
