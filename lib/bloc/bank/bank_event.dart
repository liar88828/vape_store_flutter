part of 'bank_bloc.dart';

@immutable
sealed class BankEvent {}

final class BankLoadsEvent extends BankEvent {}

final class BankSelectEvent extends BankEvent {
  final BankModel? bank;
  BankSelectEvent({required this.bank});
}

final class BankRemoveEvent extends BankEvent {
  final BankModel bank;
  BankRemoveEvent({required this.bank});
}
