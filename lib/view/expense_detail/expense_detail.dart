import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/blocs/finance/finance_bloc.dart';
import 'package:personal_finance_tracker/constants/color_constants.dart';
import 'package:personal_finance_tracker/models/finance_model.dart';
import 'package:personal_finance_tracker/view/edit_expense/edit_expense.dart';
import 'package:personal_finance_tracker/view/home/home.dart';

class ExpenseDetail extends StatelessWidget {
  const ExpenseDetail({super.key, required this.expense});
  final Finance expense;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: ColorConstants.PRIMARYCOLOR),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditExpenseScreen(expense: expense),
                ), // Pass the Finance object to edit
              );
            },
          ),

          IconButton(
            disabledColor: Colors.red,
            splashColor: Colors.red,
            hoverColor: Colors.red,
            focusColor: Colors.red,
            highlightColor: Colors.red,
            onPressed: () {
              context.read<FinanceBloc>().add(
                DeleteExpenseEvent(id: expense.id),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
            },
            icon: Icon(Icons.delete),
            color: Colors.red,
            iconSize: 35,
          ),
        ],
      ),
      body: Center(
        child: Container(
          height: 500,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: ColorConstants.PRIMARYCOLOR,

            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black,
                offset: Offset(00, 10),
              ),
            ],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                "₹ ${expense.amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 30,
                  color: ColorConstants.TEXTCOLOR,

                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Type: ${expense.type}",
                style: TextStyle(
                  fontSize: 25,
                  color: ColorConstants.TEXTCOLOR,

                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Category: ${expense.category}",
                style: TextStyle(
                  fontSize: 25,
                  color: ColorConstants.TEXTCOLOR,

                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Date: ${expense.date.toLocal().toString().split(' ')[0]}",
                style: TextStyle(
                  fontSize: 22,
                  color: ColorConstants.TEXTCOLOR,

                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Description: ${expense.description ?? "No Description"}",
                style: TextStyle(
                  fontSize: 20,
                  color: ColorConstants.TEXTCOLOR,

                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
