// ignore_for_file: overridden_fields

part of 'bank_bloc.dart';

@immutable
sealed class BankState {
  final List<BankModel> banks;
  final BankModel? bank;
  const BankState({
    this.banks = const [],
    this.bank,
  });
}

final class BankInitial extends BankState {}

final class BankLoadingState extends BankState {}

final class BankLoadsState extends BankState {
  final List<BankModel> banks;
  const BankLoadsState({required this.banks}) : super(banks: banks);
}

final class BankErrorState extends BankState {
  final String message;
  const BankErrorState({required this.message});
}

final class BankSelectState extends BankState {
  @override
  final BankModel? bank;
  const BankSelectState({required this.bank}) : super(bank: bank);
}

final class BankRemoveState extends BankState {
  @override
  final BankModel bank;
  const BankRemoveState({required this.bank}) : super(bank: bank);
}
