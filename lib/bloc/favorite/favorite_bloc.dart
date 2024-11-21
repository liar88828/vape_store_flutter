import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vape_store/models/favorite_list_model.dart';
import 'package:vape_store/models/favorite_model.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/network/favorite_network.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteNetwork favoriteRepository;
  final Future<UserModel> session;
  FavoriteBloc({required this.favoriteRepository, required this.session}) : super(FavoriteInitial()) {
    on<FavoriteLoadsEvent>((event, emit) async {
      emit(FavoriteLoadingState());
      try {
        final user = await session;
        final data = await favoriteRepository.fetchFavoritesByUserId(user.id);
        emit(FavoriteLoadsState(favorites: data, count: data.length));
      } catch (e) {
        emit(FavoriteErrorState(message: e.toString()));
      }
    });

    on<FavoriteUpdateEvent>((event, emit) async {
      emit(FavoriteLoadingState());
      try {
        final data = await favoriteRepository.updateFavorite(event.favorite);
        emit(FavoriteUpdateState(message: data.message));
      } catch (e) {
        emit(FavoriteErrorState(message: e.toString()));
      }
    });

    on<FavoriteDeleteEvent>((event, emit) async {
      emit(FavoriteLoadingState());
      try {
        final data = await favoriteRepository.deleteFavorite(event.id);
        emit(FavoriteDeleteState(message: data.message));
      } catch (e) {
        emit(FavoriteErrorState(message: e.toString()));
      }
    });
    on<FavoriteListIdEvent>((event, emit) async {
      emit(FavoriteLoadingState());
      try {
        final data = await favoriteRepository.fetchFavoritesByListId(event.id);
        emit(FavoriteListIdState(favoriteList: data));
      } catch (e) {
        emit(FavoriteErrorState(message: e.toString()));
      }
    });

    on<FavoriteCountByUserId>((event, emit) async {
      emit(FavoriteLoadingState());
      try {
        final user = await session;
        final data = await favoriteRepository.fetchFavoritesByUserIdCount(user.id);
        emit(FavoriteInitial(count: data));
      } catch (e) {
        emit(FavoriteErrorState(message: e.toString()));
      }
    });
  }
}
