part of 'finance_bloc.dart';

class FinanceState {}

class FinanceInitial extends FinanceState {}

class FinanceLoaded extends FinanceState {
  final List<Finance> history;
  final double totalBalance;
  FinanceLoaded({required this.history, required this.totalBalance});
}

class ExpenseBasedonMonthState extends FinanceState {
  final List<Finance> history;
  final double totalBalance;
  ExpenseBasedonMonthState({required this.history, required this.totalBalance});
}

class ExpenseBasedonDateState extends FinanceState {
  final List<Finance> history;
  final double totalBalance;
  ExpenseBasedonDateState({required this.history, required this.totalBalance});
}

class LoadingState extends FinanceState {}

class FilteredHistoryState extends FinanceState {
  final List<Finance> history;
  final double totalBalance;
  FilteredHistoryState({required this.history, required this.totalBalance});
}

class SortedState extends FinanceState {
  final List<Finance> history;
  final double totalBalance;
  SortedState({required this.history, required this.totalBalance});
}

class AllFinanceState extends FinanceState {
  final List<Finance> history;
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final double avgMonthlyIncome;
  final double avgMonthlyExpense;
  AllFinanceState({
    required this.history,
    required this.totalBalance,
    required this.totalExpense,
    required this.totalIncome,
    required this.avgMonthlyExpense,
    required this.avgMonthlyIncome,
  });
}
