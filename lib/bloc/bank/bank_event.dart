part of 'bank_bloc.dart';

@immutable
sealed class BankEvent {}

final class BankLoadsEvent extends BankEvent {}
