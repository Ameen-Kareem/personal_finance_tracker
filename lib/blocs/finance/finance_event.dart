part of 'finance_bloc.dart';

class FinanceEvent {}

class AddFinanceEvent extends FinanceEvent {
  double amount;
  String category;
  DateTime date;
  String type;
  String? description;
  AddFinanceEvent({
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
  });
}

class FetchHistoryEvent extends FinanceEvent {}

class FetchHistoryBasedonDateEvent extends FinanceEvent {
  DateTime date;
  FetchHistoryBasedonDateEvent({required this.date});
}

class FetchHistoryEventBasedonMonth extends FinanceEvent {
  FetchHistoryEventBasedonMonth({required this.month});
  DateTime month;
}

class DeleteExpenseEvent extends FinanceEvent {
  int id;
  DeleteExpenseEvent({required this.id});
}

class FilterByTypeAndCategoryEvent extends FinanceEvent {
  final String? type; // 'Income', 'Expense', or null for all
  final String? category; // 'Food', 'Salary', etc., or null for all

  FilterByTypeAndCategoryEvent({this.type, this.category});
}

class SortByDateEvent extends FinanceEvent {
  final bool ascending;
  SortByDateEvent({required this.ascending});
}

class UpdateFinanceEvent extends FinanceEvent {
  final Finance finance;
  UpdateFinanceEvent({required this.finance});
}

class FetchFinancesEvent extends FinanceEvent {}
