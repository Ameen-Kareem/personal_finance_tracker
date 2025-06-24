import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/blocs/finance/finance_bloc.dart';
import 'package:personal_finance_tracker/constants/color_constants.dart';
import 'package:personal_finance_tracker/models/finance_model.dart';
import 'package:personal_finance_tracker/view/expense_detail/expense_detail.dart';
import 'package:personal_finance_tracker/view/widgets/custom_widgets.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Transaction History',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'asc') {
                context.read<FinanceBloc>().add(
                  SortByDateEvent(ascending: true),
                );
              } else {
                context.read<FinanceBloc>().add(
                  SortByDateEvent(ascending: false),
                );
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: 'asc', child: Text('Sort by Date ↑')),
                  PopupMenuItem(value: 'desc', child: Text('Sort by Date ↓')),
                ],
            icon: Icon(Icons.sort),
          ),

          IconButton(
            onPressed: () => _showFilterOptions(context),
            icon: Icon(Icons.filter_alt_sharp),
          ),
        ],
      ),
      body: BlocBuilder<FinanceBloc, FinanceState>(
        builder: (context, state) {
          if (state is FinanceLoaded) {
            final history = state.history;
            if (history.isEmpty) {
              return const Center(child: Text("No transactions yet."));
            }
            return Column(
              children: [
                currentBalanceArea(state.totalBalance.toStringAsFixed(2)),
                Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final transaction = history[index];
                      return IncomeExpenseCardArea(transaction, context);
                    },
                  ),
                ),
              ],
            );
          } else if (state is SortedState) {
            final history = state.history;
            if (history.isEmpty) {
              return const Center(child: Text("No transactions yet."));
            }
            return Column(
              children: [
                currentBalanceArea(state.totalBalance.toStringAsFixed(2)),
                Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final transaction = history[index];
                      return IncomeExpenseCardArea(transaction, context);
                    },
                  ),
                ),
              ],
            );
          } else if (state is FinanceInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FilteredHistoryState) {
            final history = state.history;
            if (history.isEmpty) {
              return const Center(child: Text("No transactions."));
            }
            return Column(
              children: [
                currentBalanceArea(state.totalBalance.toStringAsFixed(2)),
                Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final transaction = history[index];
                      return IncomeExpenseCardArea(transaction, context);
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("Failed to load history."));
          }
        },
      ),
    );
  }

  currentBalanceArea(String balance) {
    return Container(
      height: 140,
      width: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),

        color: ColorConstants.PRIMARYCOLOR,

        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 5, offset: Offset(0, 5)),
        ],
      ),
      child: Text(
        "Current Balance: ₹${balance}",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ColorConstants.TEXTCOLOR,
        ),
      ),
    );
  }

  IncomeExpenseCardArea(Finance transaction, BuildContext context) {
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

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String? selectedType;
        String? selectedCategory;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filter Transactions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: selectedType,
                    hint: const Text("Select Type"),
                    items:
                        ['Income', 'Expense']
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) => setModalState(() {
                          selectedType = value;
                        }),
                  ),

                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    hint: const Text("Select Category"),
                    items:
                        [
                              if (selectedType == 'Income') ...[
                                'Salary',
                                'Misc',
                              ],
                              if (selectedType == 'Expense') ...[
                                'Food',
                                'Transport',
                                'Bills',
                                'Rent',
                                'Misc',
                              ],
                              if (selectedType == null) ...[],
                            ]
                            .map<DropdownMenuItem<String>>(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) => setModalState(() {
                          selectedCategory = value;
                        }),
                  ),
                  const SizedBox(height: 20),
                  CustomWidgets().CustomButton(
                    maxHeight: 50,
                    maxWidth: double.infinity,
                    minHeight: 50,
                    minWidth: double.infinity,
                    functionality: () {
                      context.read<FinanceBloc>().add(
                        FilterByTypeAndCategoryEvent(
                          type: selectedType,
                          category: selectedCategory,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    text: "Apply Filter",
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
