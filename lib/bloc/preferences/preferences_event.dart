part of 'preferences_bloc.dart';

@immutable
sealed class PreferencesEvent {}

class LoadPreferencesEvent extends PreferencesEvent {}

class TogglePreferencesEvent extends PreferencesEvent {}

class LoadUserPrefEvent extends PreferencesEvent {}

class LoadTokenPrefEvent extends PreferencesEvent {}

class SetUserPrefEvent extends PreferencesEvent {
  final UserModel userData;
  SetUserPrefEvent({required this.userData});
}

class SetTokenPrefEvent extends PreferencesEvent {
  final String token;
  SetTokenPrefEvent({required this.token});
}

class SetDarkThemeEvent extends PreferencesEvent {}

class SetLightThemeEvent extends PreferencesEvent {}

class GetThemeEvent extends PreferencesEvent {}
