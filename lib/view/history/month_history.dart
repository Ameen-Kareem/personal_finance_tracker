import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/blocs/finance/finance_bloc.dart';
import 'package:personal_finance_tracker/constants/color_constants.dart';
import 'package:personal_finance_tracker/models/finance_model.dart';
import 'package:personal_finance_tracker/view/expense_detail/expense_detail.dart';

class MonthHistory extends StatefulWidget {
  const MonthHistory({super.key, required this.month});
  final DateTime month;
  @override
  State<MonthHistory> createState() => _MonthHistoryState();
}

class _MonthHistoryState extends State<MonthHistory> {
  @override
  void initState() {
    super.initState();
    month = widget.month;
    context.read<FinanceBloc>().add(
      FetchHistoryEventBasedonMonth(month: month),
    );
  }

  late DateTime month;
  List<Finance>? history;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
          color: ColorConstants.PRIMARYCOLOR,
        ),
        title: Text(
          "Transactions on ${month.toLocal().toString().split(' ')[0]}",
          style: TextStyle(
            fontSize: 20,
            color: ColorConstants.PRIMARYCOLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          BlocBuilder<FinanceBloc, FinanceState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is ExpenseBasedonMonthState) {
                history = state.history;
                if (history!.isEmpty) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "No transaction on ${month.toLocal().toString().split(' ')[0]}",
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: history!.length,
                    itemBuilder: (context, index) {
                      final transaction = history![index];
                      return IncomeExpenseCardArea(transaction);
                    },
                  ),
                );
              }
              return Center(child: Text("state is $state"));
            },
          ),
        ],
      ),
    );
  }

  IncomeExpenseCardArea(Finance transaction) {
    return InkWell(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExpenseDetail(expense: transaction),
            ),
          ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          leading: Icon(
            transaction.type == 'Expense'
                ? Icons.arrow_downward
                : Icons.arrow_upward,
            color:
                transaction.type == 'Income'
                    ? ColorConstants.INCOMECOLOR
                    : ColorConstants.EXPENSECOLOR,
          ),
          title: Text(
            "${transaction.category} - ₹${transaction.amount.toStringAsFixed(2)}",
          ),
          subtitle: Text(
            "${transaction.date.toLocal().toString().split(' ')[0]} — ${transaction.description ?? 'No description'}",
          ),
          trailing: Text(
            transaction.type.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
                  transaction.type == 'Income'
                      ? ColorConstants.INCOMECOLOR
                      : ColorConstants.EXPENSECOLOR,
            ),
          ),
        ),
      ),
    );
  }
}
