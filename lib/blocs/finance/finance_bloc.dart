import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:personal_finance_tracker/models/finance_helper.dart';
import 'package:personal_finance_tracker/models/finance_model.dart';

part 'finance_event.dart';
part 'finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  late ObjectBox objectBox;
  FinanceBloc() : super(FinanceInitial()) {
    on<AddFinanceEvent>((event, emit) {
      emit(LoadingState());

      objectBox.addFinance(event);
      final history = objectBox.getAllHistory();
      emit(
        FinanceLoaded(
          history: history,
          totalBalance: objectBox.getTotalBalance(),
        ),
      );
    });
    on<FetchHistoryEvent>((event, emit) {
      emit(LoadingState());
      final history = objectBox.getAllHistory();
      emit(
        FinanceLoaded(
          history: history,
          totalBalance: objectBox.getTotalBalance(),
        ),
      );
    });

    on<FetchHistoryBasedonDateEvent>((event, emit) {
      emit(LoadingState());
      final history = objectBox.getHistoryByDate(event.date);
      emit(
        ExpenseBasedonDateState(
          history: history,
          totalBalance: objectBox.getTotalBalance(),
        ),
      );
    });

    on<FetchHistoryEventBasedonMonth>((event, emit) {
      emit(LoadingState());

      final history = objectBox.getHistoryByMonth(event.month);
      emit(
        ExpenseBasedonMonthState(
          history: history,
          totalBalance: objectBox.getTotalBalance(),
        ),
      );
    });
    on<DeleteExpenseEvent>((event, emit) {
      emit(LoadingState());

      objectBox.deleteFinance(event.id);
      final history = objectBox.getAllHistory();

      emit(
        FinanceLoaded(
          history: history,
          totalBalance: objectBox.getTotalBalance(),
        ),
      );
    });
    on<FilterByTypeAndCategoryEvent>((event, emit) {
      emit(LoadingState());

      final filtered = objectBox.getFilteredHistory(
        type: event.type,
        category: event.category,
      );

      emit(
        FilteredHistoryState(
          history: filtered,
          totalBalance:
              objectBox
                  .getTotalBalance(), // Optional: or recalculate from filtered list
        ),
      );
    });
    on<SortByDateEvent>((event, emit) {
      emit(LoadingState());

      List<Finance> history = objectBox.getAllHistory();

      history.sort(
        (a, b) =>
            event.ascending
                ? a.date.compareTo(b.date)
                : b.date.compareTo(a.date),
      );

      emit(
        SortedState(
          history: history,
          totalBalance: objectBox.getTotalBalance(),
        ),
      );
    });
    on<UpdateFinanceEvent>((event, emit) {
      emit(LoadingState());
      objectBox.updateFinance(event.finance);
      emit(
        FinanceLoaded(
          history: objectBox.getAllHistory(),
          totalBalance: objectBox.getTotalBalance(),
        ),
      );
    });
    on<FetchFinancesEvent>((event, emit) {
      emit(LoadingState());

      emit(
        AllFinanceState(
          totalBalance: objectBox.getTotalBalance(),
          totalIncome: objectBox.getTotalIncome(),
          totalExpense: objectBox.getTotalExpense(),
          avgMonthlyIncome: objectBox.getAverageMonthlyIncome(),
          avgMonthlyExpense: objectBox.getAverageMonthlyExpense(),
        ),
      );
    });
  }

  static Future<FinanceBloc> create() async {
    final bloc = FinanceBloc();
    bloc.objectBox = await ObjectBox.create();
    bloc.add(FetchFinancesEvent()); // now safe
    return bloc;
  }
}
