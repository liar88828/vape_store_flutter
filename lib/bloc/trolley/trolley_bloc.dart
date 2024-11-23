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
        if (event.type.isEmpty) {
          emit(const TrolleyCaseErrorState(message: 'Please Add type'));
        } else if (event.qty <= 0) {
          emit(const TrolleyCaseErrorState(message: 'The Qty Cannot 0 or less'));
        } else {
          final user = await session;
          final response = await trolleyRepository.addTrolley(TrolleyCreate(
            id: event.id,
            idProduct: event.idProduct,
            qty: event.qty,
            idUser: user.id,
            type: event.type,
          ));
          emit(TrolleyCaseState(response: response));
        }
      } catch (e) {
        emit(TrolleyCaseErrorState(message: e.toString()));
      }
    });

    on<TrolleyRemoveEvent>((event, emit) async {
      emit(TrolleyLoadingState());
      try {
        final response = await trolleyRepository.removeTrolley(event.idTrolley);
        emit(TrolleyRemoveState(message: response.message));
      } catch (e) {
        emit(TrolleyErrorState(message: e.toString()));
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

    on<TrolleySelectEvent>((event, emit) {
      final cartItems = List<TrolleyModel>.from(state.cartItems);
      if (event.isSelected == true) {
        cartItems.add(event.item);
        // print(cartItems.last.name);
        emit(TrolleyInitial(
          cartItems: cartItems,
          trolleys: state.trolleys,
          totalPrice: _calculateTotalPrice(cartItems),
        ));
      } else {
        cartItems.remove(event.item);
        emit(TrolleyInitial(
          cartItems: cartItems,
          trolleys: state.trolleys,
          totalPrice: _calculateTotalPrice(cartItems),
        ));
      }
    });

    on<TrolleyIncrementEvent>((event, emit) {
      event.item.trolleyQty++;
      final trolleys = state.trolleys.map((data) {
        if (data.idTrolley == event.item.idTrolley) {
          data = event.item;
          return data;
        }
        return data;
      }).toList();
      final cartItems = state.cartItems;
      emit(TrolleyInitial(
        trolleys: trolleys,
        cartItems: state.cartItems,
        totalPrice: _calculateTotalPrice(cartItems),
      ));
    });

    on<TrolleyDecrementEvent>((event, emit) {
      if (event.item.trolleyQty > 1) {
        event.item.trolleyQty--;
        final trolleys = state.trolleys.map((data) {
          if (data.idTrolley == event.item.idTrolley) {
            data = event.item;
            return data;
          }
          return data;
        }).toList();
        final cartItems = state.cartItems;
        emit(TrolleyInitial(
          trolleys: trolleys,
          cartItems: state.cartItems,
          totalPrice: _calculateTotalPrice(cartItems),
        ));
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

num _calculateTotalPrice(List<TrolleyModel> items) {
  return items.fold(0, (total, item) => total + (item.price * item.trolleyQty));
}
