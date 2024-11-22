part of 'bank_bloc.dart';

@immutable
sealed class BankState {
  final List<BankModel>? bankList;
  final BankModel? bank;
  BankState({
    this.bankList,
    this.bank,
  });
}

final class BankInitial extends BankState {}

final class BankLoadingState extends BankState {}

final class BankLoadsState extends BankState {
  final List<BankModel> banks;
  BankLoadsState({required this.banks}) : super(bankList: banks);
}

final class BankErrorState extends BankState {
  final String message;
  BankErrorState({required this.message});
}

final class BankSelectState extends BankState {
  @override
  final BankModel bank;
  BankSelectState({required this.bank}) : super(bank: bank);
}

final class BankRemoveState extends BankState {
  @override
  final BankModel bank;
  BankRemoveState({required this.bank}) : super(bank: bank);
}
