// ignore_for_file: overridden_fields

part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  final UserModel? user;
  final String? token;
  const AuthState({this.token, this.user});
}

final class AuthInitialState extends AuthState {
  const AuthInitialState({required super.user});
}

class AuthErrorState extends AuthState {
  final String message;
  const AuthErrorState(this.message);
}

class AuthLoadingState extends AuthState {}

class AuthLoadedState extends AuthState {
  @override
  final UserModel user;
  @override
  final String token;
  const AuthLoadedState({required this.user, required this.token}) : super(user: user, token: token);
}
