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
        if (state.favorites == null) {
          final user = await session;
          final data = await favoriteRepository.fetchFavoritesByUserId(user.id);
          emit(FavoriteLoadsState(favorites: data, count: data.length));
        }
        if (state.favorites != null) {
          emit(FavoriteLoadsState(favorites: state.favorites!, count: state.favorites!.length));
        }
      } catch (e) {
        emit(FavoriteErrorState(message: e.toString()));
      }
    });

    on<FavoriteUpdateEvent>((event, emit) async {
      emit(FavoriteLoadingState());
      try {
        final user = await session;
        final data = await favoriteRepository.updateFavoriteCase(FavoriteModel(
          id: event.favorite.id,
          idUser: user.id,
          title: event.favorite.title,
          description: event.favorite.description,
        ));
        emit(FavoriteUpdateState(message: data.message));
      } catch (e) {
        emit(FavoriteErrorState(message: e.toString()));
      }
    });

    on<FavoriteCreateEvent>((event, emit) async {
      emit(FavoriteLoadingState());
      try {
        final user = await session;
        final response = await favoriteRepository.createFavoriteCase(FavoriteModel(
          id: null,
          idUser: user.id,
          title: event.favorite.title,
          description: event.favorite.description,
        ));
        emit(FavoriteUpdateState(message: response));
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
    on<FavoriteAddListEvent>((event, emit) async {
      emit(FavoriteLoadingState());
      try {
        final data = await favoriteRepository.addFavoriteList(event.favorite);
        emit(FavoriteSuccessState(message: data.message));
      } catch (e) {
        emit(FavoriteErrorState(message: e.toString()));
      }
    });

    on<FavoriteListUserEvent>((event, emit) async {
      emit(FavoriteLoadingState());
      try {
        final data = await favoriteRepository.fetchFavorites();
        emit(FavoriteListUserState(favoriteList: data));
      } catch (e) {
        emit(FavoriteErrorState(message: e.toString()));
      }
    });

    on<FavoriteListIdEvent>((event, emit) async {
      emit(FavoriteLoadingState());
      try {
        final data = await favoriteRepository.fetchFavoritesByListId(event.idFavorite);
        emit(FavoriteListIdState(favoriteList: data));
      } catch (e) {
        emit(FavoriteErrorState(message: e.toString()));
      }
    });

    on<FavoriteListIdUserEvent>((event, emit) async {
      emit(FavoriteLoadingState());
      try {
        final data = await favoriteRepository.fetchFavoriteById(event.idFavorite);
        // print(data.description);
        // print('For form');
        emit(FavoriteListIdUserState(favorite: data));
      } catch (e) {
        emit(FavoriteErrorState(message: e.toString()));
      }
    });

    on<FavoriteListDeleteEvent>((event, emit) async {
      emit(FavoriteLoadingState());
      try {
        final response = await favoriteRepository.deleteToFavoriteList(event.idFavoriteList);
        emit(FavoriteDeleteSuccessState(message: response.message));
      } catch (e) {
        emit(FavoriteErrorState(message: e.toString()));
      }
    });
  }
}
