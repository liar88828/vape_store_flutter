part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  final UserModel? user;
  final String token;
  AuthState({this.token = '', this.user});
}

final class AuthInitialState extends AuthState {
  final UserModel? user;
  AuthInitialState({required this.user}) : super(user: user);
}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState(
    this.message,
  );
}

class AuthLoadingState extends AuthState {}

class AuthLoadedState extends AuthState {
  @override
  final UserModel user;
  @override
  final String token;
  AuthLoadedState({required this.user, required this.token});
}
