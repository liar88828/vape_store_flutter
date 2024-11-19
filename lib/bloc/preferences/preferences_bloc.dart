import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/repository/preferences_repo.dart';

part 'preferences_event.dart';
part 'preferences_state.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  final PreferencesRepository preferencesRepository;

  PreferencesBloc({
    required this.preferencesRepository,
  }) : super(PreferencesState()) {
    // on<LoadPreferencesEvent>(_onLoadTheme);
    on<GetThemeEvent>((event, emit) async {
      print('dark theme');

      await preferencesRepository.setDarkMode(true);
      emit(PrefDarkModeState(isDarkMode: true));
    });

    on<SetLightThemeEvent>((event, emit) async {
      await preferencesRepository.setDarkMode(false);
      emit(PrefDarkModeState(isDarkMode: false));
    });

    on<LoadPreferencesEvent>((event, emit) async {
      emit(PrefLoadingState());
      bool theme = await preferencesRepository.getDarkMode();
      emit(PrefDarkModeState(isDarkMode: theme));
    });

    on<LoadUserPrefEvent>((event, emit) async {
      // emit(PrefLoadingState());
      final user = await preferencesRepository.getUser();
      emit(PrefUserState(user: user));
    });

    on<SetUserPrefEvent>((event, emit) async {
      await preferencesRepository.setUser(event.userData);
      emit(PrefUserState(user: event.userData));
    });

    on<SetTokenPrefEvent>((event, emit) async {
      await preferencesRepository.setToken(event.token);
      emit(PrefTokenState(token: event.token));
    });
  }

  // Future<void> _onLoadTheme(
  //   LoadPreferencesEvent event,
  //   Emitter<PreferencesState> emit,
  // ) async {
  //   emit(state.copyWith(isLoading: true));
  //   final isDarkMode = await preferencesRepository.getDarkMode();
  //   emit(state.copyWith(isDarkMode: isDarkMode, isLoading: false));
  // }

  // Future<void> _onToggleTheme(
  //   TogglePreferencesEvent event,
  //   Emitter<PreferencesState> emit,
  // ) async {
  //   final newDarkMode = !state.isDarkMode;
  //   await preferencesRepository.setDarkMode(newDarkMode);
  //   emit(state.copyWith(isDarkMode: newDarkMode));
  // }
}
