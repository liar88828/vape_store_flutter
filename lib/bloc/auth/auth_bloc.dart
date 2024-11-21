import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/network/user_network.dart';
import 'package:vape_store/repository/preferences_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserNetwork authRepository;
  final PreferencesRepository preferencesRepository;

  AuthBloc({
    required this.authRepository,
    required this.preferencesRepository,
  }) : super(const AuthInitialState(user: null)) {
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final data = await authRepository.login(event.email, event.password);
        await preferencesRepository.setToken(data.token);
        await preferencesRepository.setUser(data.user);
        emit(AuthLoadedState(token: data.token, user: data.user));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<AuthRegisterEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final data = await authRepository.register(email: event.email, name: event.name, password: event.password);
        await preferencesRepository.setToken(data.token);
        await preferencesRepository.setUser(data.user);
        emit(AuthLoadedState(token: data.token, user: data.user));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });

    on<AuthLogoutEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await authRepository.logout();
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      } finally {
        await preferencesRepository.deleteToken();
        await preferencesRepository.deleteUser();
      }
    });

    on<AuthInfoEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final user = await preferencesRepository.getUser();
        final token = await preferencesRepository.getToken();
        emit(AuthLoadedState(user: user, token: token));
      } catch (e) {
        emit(AuthErrorState(e.toString()));
      }
    });
  }
}
