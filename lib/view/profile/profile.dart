import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/blocs/authentication/authentication_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  Profile({super.key});
  void initState() {
    () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      username = await prefs.getString('currentUser');
      log("usename:$username");
    };
  }

  String? username;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          Container(
            alignment: Alignment.center,
            child: Column(
              spacing: 20,
              children: [
                Icon(Icons.person, size: 130),
                Text(
                  username ?? "Username not found",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    context.read<AuthenticationBloc>().add(LogOutEvent());
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Row(
                    spacing: 20,
                    children: [
                      const SizedBox(width: 20),
                      Icon(Icons.logout, size: 30),
                      Text(
                        "Log Out",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
