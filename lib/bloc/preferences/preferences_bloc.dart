import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/repository/preferences_repo.dart';

part 'preferences_event.dart';
part 'preferences_state.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  final PreferencesRepository preferencesRepository;

  PreferencesBloc({
    required this.preferencesRepository,
  }) : super(const PreferencesState()) {
    // on<LoadPreferencesEvent>(_onLoadTheme);
    on<GetThemeEvent>((event, emit) async {
      await preferencesRepository.setDarkMode(true);
      emit(const PrefDarkModeState(isDarkMode: true));
    });

    on<SetLightThemeEvent>((event, emit) async {
      await preferencesRepository.setDarkMode(false);
      emit(const PrefDarkModeState(isDarkMode: false));
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
}
