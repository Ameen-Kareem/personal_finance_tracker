import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/blocs/finance/finance_bloc.dart';
import 'package:personal_finance_tracker/constants/color_constants.dart';
import 'package:personal_finance_tracker/models/finance_model.dart';
import 'package:personal_finance_tracker/view/history/date_history.dart';
import 'package:personal_finance_tracker/view/history/month_history.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    context.read<FinanceBloc>().add(FetchFinancesEvent());
  }

  double? totalBalance;
  double? totalIncome;
  double? totalExpense;
  double? avgIncome;
  double? avgExpense;
  DateTime? _selectedDate;
  DateTime? _selectedMonth;
  List<Finance> history = [];
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedMonth = picked; // Your state variable
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black,
        toolbarHeight: 70,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Text(
          "Dime Drop",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: BlocBuilder<FinanceBloc, FinanceState>(
        builder: (context, state) {
          if (state is FinanceInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FinanceLoaded) {
            totalBalance = state.totalBalance;
          } else if (state is AllFinanceState) {
            history = state.history;
            totalBalance = state.totalBalance;
            totalIncome = state.totalIncome;
            totalExpense = state.totalExpense;
            avgIncome = state.avgMonthlyIncome;
            avgExpense = state.avgMonthlyExpense;
          }
          if (state is LoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          if (history.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                Text(
                  "No transactions yet!",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/expense'),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(blurRadius: 4, offset: Offset(00, 04)),
                      ],
                    ),
                    child: Text(
                      "Add Income or Expense",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: buildPieChart(totalIncome ?? 0, totalExpense ?? 0),
                  ),
                  currentBalanceArea(
                    totalBalance?.toStringAsFixed(2) ?? "0.00",
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      optionContainer(
                        content:
                            "Total Income:\n${totalIncome?.toStringAsFixed(2) ?? 0}",
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      optionContainer(
                        content: "Total Expense:\n${totalExpense ?? 0}",
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black,

                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      optionContainer(
                        content: "Avg Income:\n${avgIncome ?? 0}",
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: ColorConstants.TEXTCOLOR,

                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      optionContainer(
                        content: "Avg Expense:\n${avgExpense ?? 0}",
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: ColorConstants.TEXTCOLOR,

                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: GridView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                          ),
                      children: [
                        optionContainer(
                          content: "Add Income\nor Expense",
                          funcationality:
                              () => Navigator.pushNamed(context, '/expense'),
                        ),
                        optionContainer(
                          content: "History based\non a Month",
                          funcationality: () async {
                            await _selectMonth(context);
                            if (_selectedMonth != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          MonthHistory(month: _selectedMonth!),
                                ),
                              );
                            }
                          },
                        ),
                        optionContainer(
                          content: "History based\non a Date",
                          funcationality: () async {
                            await _pickDate(context);
                            if (_selectedDate != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          DateHistory(date: _selectedDate!),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget currentBalanceArea(String balance) {
    return Container(
      height: 140,
      width: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),

        color: ColorConstants.CARD,
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

  optionContainer({
    required String content,
    Function()? funcationality,
    TextStyle? textStyle,
  }) {
    return InkWell(
      onTap: funcationality,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: ColorConstants.CARD,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(00, 03),
              blurRadius: 3,
            ),
          ],
        ),
        child: Text(
          content,
          style:
              textStyle ??
              TextStyle(
                fontSize: 15,
                color: ColorConstants.TEXTCOLOR,

                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }

  Widget buildPieChart(double income, double expense) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: ColorConstants.INCOMECOLOR,
            value: income,
            title: 'Income',
            radius: 125,
            titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorConstants.TEXTCOLOR,
            ),
          ),
          PieChartSectionData(
            color: ColorConstants.EXPENSECOLOR,
            value: expense,
            title: 'Expense',
            radius: 125,
            titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorConstants.TEXTCOLOR,
            ),
          ),
        ],
        sectionsSpace: 0,
        centerSpaceRadius: 0,
      ),
    );
  }
}
