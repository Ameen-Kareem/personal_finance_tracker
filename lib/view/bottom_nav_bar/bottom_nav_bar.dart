import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/blocs/finance/finance_bloc.dart';
import 'package:personal_finance_tracker/constants/color_constants.dart';
import 'package:personal_finance_tracker/view/history/history.dart';
import 'package:personal_finance_tracker/view/home/home.dart';
import 'package:personal_finance_tracker/view/profile/profile.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> _navItems = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ];
    List _screens = [Home(), TransactionHistoryScreen(), Profile()];
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _currentIndex,
        onTap: (int index) {
          if (index == 1) {
            context.read<FinanceBloc>().add(FetchHistoryEvent());
          } else if (index == 0) {
            context.read<FinanceBloc>().add(FetchFinancesEvent());
          }
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        selectedItemColor: ColorConstants.CARD,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
