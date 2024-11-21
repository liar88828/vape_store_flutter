part of 'bank_bloc.dart';

@immutable
sealed class BankState {}

final class BankInitial extends BankState {}

final class BankLoadingState extends BankState {}

final class BankLoadsState extends BankState {
  final List<BankModel> banks;
  BankLoadsState({required this.banks});
}

final class BankErrorState extends BankState {
  final String message;
  BankErrorState({required this.message});
}
