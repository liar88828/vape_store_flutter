part of 'favorite_bloc.dart';

@immutable
sealed class FavoriteEvent {}

final class FavoriteLoadsEvent extends FavoriteEvent {}

final class FavoriteLoadEvent extends FavoriteEvent {
  final int idUser;
  FavoriteLoadEvent({required this.idUser});
}

final class FavoriteUpdateEvent extends FavoriteEvent {
  final FavoriteModel favorite;
  FavoriteUpdateEvent({required this.favorite});
}

final class FavoriteCreateEvent extends FavoriteEvent {
  final FavoriteModel favorite;
  FavoriteCreateEvent({required this.favorite});
}

final class FavoriteDeleteEvent extends FavoriteEvent {
  final int id;
  FavoriteDeleteEvent({required this.id});
}

final class FavoriteListIdEvent extends FavoriteEvent {
  final int idFavorite;
  FavoriteListIdEvent({required this.idFavorite});
}

final class FavoriteCountByUserId extends FavoriteEvent {}

final class FavoriteAddListEvent extends FavoriteEvent {
  final FavoriteListCreate favorite;
  FavoriteAddListEvent({required this.favorite});
}

final class FavoriteListUserEvent extends FavoriteEvent {
  // final int idFavorite;
  // FavoriteListUserEvent({required this.idFavorite});
}

final class FavoriteListIdUserEvent extends FavoriteEvent {
  final int idFavorite;
  FavoriteListIdUserEvent({required this.idFavorite});
}

final class FavoriteListDeleteEvent extends FavoriteEvent {
  final int idFavoriteList;
  FavoriteListDeleteEvent({required this.idFavoriteList});
}
