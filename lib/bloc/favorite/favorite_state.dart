part of 'favorite_bloc.dart';

// @immutable
sealed class FavoriteState {
  UserModel? session;
  int? count;
  List<FavoriteModel>? favorites;
  FavoriteState({this.session, this.count, this.favorites});
}

final class FavoriteInitial extends FavoriteState {
  FavoriteInitial({super.session, super.count});
}

final class FavoriteLoadingState extends FavoriteState {}

final class FavoriteSuccessState extends FavoriteState {
  final String message;
  FavoriteSuccessState({required this.message});
}

final class FavoriteErrorState extends FavoriteState {
  final String message;
  FavoriteErrorState({required this.message});
}

final class FavoriteLoadsState extends FavoriteState {
  final List<FavoriteModel> favorites;
  final int count;
  FavoriteLoadsState({required this.favorites, required this.count}) : super(favorites: favorites, count: count);
}

final class FavoriteUpdateState extends FavoriteState {
  final String message;
  FavoriteUpdateState({required this.message});
}

final class FavoriteCreateState extends FavoriteState {
  final String message;
  FavoriteCreateState({required this.message});
}

final class FavoriteDeleteState extends FavoriteState {
  final String message;
  FavoriteDeleteState({required this.message});
}

final class FavoriteListIdState extends FavoriteState {
  final List<FavoriteListModel> favoriteList;

  FavoriteListIdState({required this.favoriteList});
}

final class FavoriteListUserState extends FavoriteState {
  final List<FavoriteModel> favoriteList;
  FavoriteListUserState({required this.favoriteList});
}

final class FavoriteListIdUserState extends FavoriteState {
  final FavoriteModel favorite;
  FavoriteListIdUserState({required this.favorite});
}

final class FavoriteDeleteSuccessState extends FavoriteState {
  final String message;
  FavoriteDeleteSuccessState({required this.message});
}
