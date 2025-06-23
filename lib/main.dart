import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/blocs/authentication/authentication_bloc.dart';
import 'package:personal_finance_tracker/blocs/finance/finance_bloc.dart';
import 'package:personal_finance_tracker/routes.dart';
import 'package:personal_finance_tracker/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:personal_finance_tracker/view/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool logStatus = await loggedIn();
  final financeBloc = await FinanceBloc.create();
  runApp(MyApp(logStatus: logStatus, financeBloc: financeBloc));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.logStatus, required this.financeBloc});
  final bool logStatus;
  final FinanceBloc financeBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationBloc()),
        BlocProvider<FinanceBloc>.value(value: financeBloc),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: logStatus ? const BottomNavBar() : const LoginScreen(),
        routes: Routes.routes,
      ),
    );
  }
}

Future<bool> loggedIn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? loggedIn = prefs.getBool('loggedIn');
  return loggedIn ?? false;
}
