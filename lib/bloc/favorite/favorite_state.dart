part of 'favorite_bloc.dart';

// @immutable
sealed class FavoriteState {
  UserModel? session;
  int? count;
  FavoriteState({this.session, this.count});
}

final class FavoriteInitial extends FavoriteState {
  FavoriteInitial({super.session, super.count});
}

final class FavoriteLoadingState extends FavoriteState {}

final class FavoriteErrorState extends FavoriteState {
  final String message;
  FavoriteErrorState({required this.message});
}

final class FavoriteLoadsState extends FavoriteState {
  final List<FavoriteModel> favorites;
  FavoriteLoadsState({required this.favorites, super.count});
}

final class FavoriteUpdateState extends FavoriteState {
  final String message;
  FavoriteUpdateState({required this.message});
}

final class FavoriteDeleteState extends FavoriteState {
  final String message;
  FavoriteDeleteState({required this.message});
}

final class FavoriteListIdState extends FavoriteState {
  final List<FavoriteListModel> favoriteList;

  FavoriteListIdState({required this.favoriteList});
}
