import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<RegisterEvent>((event, emit) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        String username = event.username;
        String password = event.password;
        String email = event.email;
        int? counter = prefs.getInt('counter');

        if (counter == null) {
          await prefs.setInt('counter', 1);
        } else {
          for (int i = 1; i <= counter; i++) {
            final List<String> user = prefs.getStringList('user$i')!;
            if (username == user[0]) {
              emit(RegisterFailedState(error: "Username already Exists!"));
            }
          }
          await prefs.setInt('counter', counter + 1);
        }
        counter = prefs.getInt('counter');
        log("counter:$counter");
        await prefs.setStringList('user$counter', <String>[
          username,
          password,
          email,
        ]);

        await prefs.setBool('loggedIn', true);
        emit(RegisterSuccessState());
      } catch (e) {
        emit(RegisterFailedState(error: e.toString()));
      }
    });
    on<LogOutEvent>((event, emit) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', false);
      emit(LoggedOutState());
    });

    on<LoginEvent>((event, emit) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String username = event.username;
      String password = event.password;
      int? counter = prefs.getInt('counter');
      bool userfound = false;
      log("inside login event");
      if (counter == null) {
        log("Not registered");
        emit(LoginFailedState(error: "Username not found"));
      } else {
        for (int i = 1; i <= counter; i++) {
          final List<String> user = prefs.getStringList('user$i')!;
          if (username == user[0] &&
              user[1] == password &&
              userfound == false) {
            userfound = true;
            log("User found");
            await prefs.setString('currentUser', username);
            await prefs.setBool('loggedIn', true);
            emit(LoginSuccesState());
          } else if (username == user[0]) {
            userfound = true;
            log("Username found");
            emit(LoginFailedState(error: "Incorrect Password"));
          }
        }
        if (userfound == false) {
          log("User not found");
          emit(LoginFailedState(error: "Username not found"));
        }
      }
    });
  }
}
// // Obtain shared preferences.
// final SharedPreferences prefs = await SharedPreferences.getInstance();

// // Save an integer value to 'counter' key.
// await prefs.setInt('counter', 10);
// // Save an boolean value to 'repeat' key.
// await prefs.setBool('repeat', true);
// // Save an double value to 'decimal' key.
// await prefs.setDouble('decimal', 1.5);
// // Save an String value to 'action' key.
// await prefs.setString('action', 'Start');
// // Save an list of strings to 'items' key.
// await prefs.setStringList('items', <String>['Earth', 'Moon', 'Sun']);
// Try reading data from the 'counter' key. If it doesn't exist, returns null.
// final int? counter = prefs.getInt('counter');
// // Try reading data from the 'repeat' key. If it doesn't exist, returns null.
// final bool? repeat = prefs.getBool('repeat');
// // Try reading data from the 'decimal' key. If it doesn't exist, returns null.
// final double? decimal = prefs.getDouble('decimal');
// // Try reading data from the 'action' key. If it doesn't exist, returns null.
// final String? action = prefs.getString('action');
// // Try reading data from the 'items' key. If it doesn't exist, returns null.
// final List<String>? items = prefs.getStringList('items');
