import '../objectbox.g.dart';
import '../models/finance_model.dart';
import '../blocs/finance/finance_bloc.dart';

class ObjectBox {
  late final Store store;
  late final Box<Finance> financeBox;

  ObjectBox._create(this.store) {
    financeBox = Box<Finance>(store);
  }

  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }

  void addFinance(AddFinanceEvent event) {
    final record = Finance(
      amount: event.amount,
      category: event.category,
      date: event.date,
      type: event.type,
      description: event.description,
    );
    financeBox.put(record);
  }

  List<Finance> getAllHistory() {
    return financeBox.getAll();
  }

  List<Finance> getHistoryByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return financeBox
        .query(
          Finance_.date
              .greaterOrEqual(startOfDay.millisecondsSinceEpoch)
              .and(Finance_.date.lessThan(endOfDay.millisecondsSinceEpoch)),
        )
        .build()
        .find();
  }

  List<Finance> getHistoryByMonth(DateTime month) {
    DateTime start = DateTime(month.year, month.month);
    DateTime end = DateTime(month.year, month.month + 1);

    return financeBox
        .query(
          Finance_.date
              .greaterOrEqual(start.millisecondsSinceEpoch)
              .and(Finance_.date.lessThan(end.millisecondsSinceEpoch)),
        )
        .build()
        .find();
  }

  double getTotalBalance() {
    final entries = financeBox.getAll();
    double total = 0;
    for (final item in entries) {
      if (item.type.toLowerCase() == 'income') {
        total += item.amount;
      } else if (item.type.toLowerCase() == 'expense') {
        total -= item.amount;
      }
    }
    return total;
  }

  void deleteFinance(int id) {
    financeBox.remove(id);
  }

  List<Finance> getFilteredHistory({String? type, String? category}) {
    Condition<Finance>? condition;

    if (type != null && type.isNotEmpty) {
      condition = Finance_.type.equals(type, caseSensitive: false);
    }

    if (category != null && category.isNotEmpty) {
      final categoryCondition = Finance_.category.equals(
        category,
        caseSensitive: false,
      );
      if (condition != null) {
        condition = condition.and(categoryCondition);
      } else {
        condition = categoryCondition;
      }
    }

    final query =
        (condition != null)
            ? financeBox.query(condition).build()
            : financeBox.query().build();

    return query.find();
  }

  void updateFinance(Finance finance) {
    financeBox.put(finance); // ObjectBox will update if ID matches
  }

  double getTotalIncome() {
    return financeBox
        .query(Finance_.type.equals('income', caseSensitive: false))
        .build()
        .find()
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double getTotalExpense() {
    return financeBox
        .query(Finance_.type.equals('expense', caseSensitive: false))
        .build()
        .find()
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double getAverageMonthlyIncome() {
    final incomes =
        financeBox
            .query(Finance_.type.equals('income', caseSensitive: false))
            .build()
            .find();

    if (incomes.isEmpty) return 0;

    final earliestDate = incomes
        .map((e) => e.date)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final latestDate = incomes
        .map((e) => e.date)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    final months = _monthDifference(earliestDate, latestDate);
    final totalIncome = incomes.fold(0.0, (sum, item) => sum + item.amount);

    return totalIncome / (months > 0 ? months : 1);
  }

  double getAverageMonthlyExpense() {
    final expenses =
        financeBox
            .query(Finance_.type.equals('expense', caseSensitive: false))
            .build()
            .find();

    if (expenses.isEmpty) return 0;

    final earliestDate = expenses
        .map((e) => e.date)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final latestDate = expenses
        .map((e) => e.date)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    final months = _monthDifference(earliestDate, latestDate);
    final totalExpense = expenses.fold(0.0, (sum, item) => sum + item.amount);

    return totalExpense / (months > 0 ? months : 1);
  }

  int _monthDifference(DateTime start, DateTime end) {
    return (end.year - start.year) * 12 + end.month - start.month + 1;
  }
}
