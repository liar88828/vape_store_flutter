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

final class FavoriteDeleteEvent extends FavoriteEvent {
  final int id;
  FavoriteDeleteEvent({required this.id});
}

final class FavoriteListIdEvent extends FavoriteEvent {
  final int id;
  FavoriteListIdEvent({required this.id});
}

final class FavoriteCountByUserId extends FavoriteEvent {}
