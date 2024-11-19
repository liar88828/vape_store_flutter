part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email, password;
  AuthLoginEvent({required this.email, required this.password});
}

class AuthRegisterEvent extends AuthEvent {
  final name, email, password;
  AuthRegisterEvent({required this.name, required this.email, required this.password});
}

class AuthLogoutEvent extends AuthEvent {}

class AuthInfoEvent extends AuthEvent {}
