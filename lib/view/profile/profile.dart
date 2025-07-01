import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/blocs/authentication/authentication_bloc.dart';
import 'package:personal_finance_tracker/constants/color_constants.dart';
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
      backgroundColor: ColorConstants.PRIMARY,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          Container(
            alignment: Alignment.center,
            child: Column(
              spacing: 20,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 130,
                    color: ColorConstants.TEXTCOLOR,
                  ),
                ),
                Text(
                  username ?? "Username",
                  style: TextStyle(
                    fontSize: 30,
                    color: ColorConstants.TEXTCOLOR,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: InkWell(
                    onTap: () {
                      context.read<AuthenticationBloc>().add(LogOutEvent());
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Row(
                      spacing: 20,
                      children: [
                        const SizedBox(width: 20),
                        Icon(
                          Icons.logout,
                          size: 30,
                          color: ColorConstants.TEXTCOLOR,
                        ),
                        Text(
                          "Log Out",
                          style: TextStyle(
                            color: ColorConstants.TEXTCOLOR,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
