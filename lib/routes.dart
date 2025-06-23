import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/view/expense/expense.dart';
import 'package:personal_finance_tracker/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:personal_finance_tracker/view/home/home.dart';
import 'package:personal_finance_tracker/view/login/login.dart';
import 'package:personal_finance_tracker/view/register/register.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/home': (context) => BottomNavBar(),
    '/login': (context) => LoginScreen(),
    '/register': (context) => RegistrationScreen(),
    '/expense': (context) => ExpenseScreen(),
  };
}
