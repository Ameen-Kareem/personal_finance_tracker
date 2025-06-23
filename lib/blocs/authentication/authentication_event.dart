part of 'authentication_bloc.dart';

class AuthenticationEvent {}

class RegisterEvent extends AuthenticationEvent {
  String username;
  String password;
  String email;
  RegisterEvent({
    required this.username,
    required this.password,
    required this.email,
  });
}

class LoginEvent extends AuthenticationEvent {
  String username;
  String password;
  LoginEvent({required this.username, required this.password});
}

class LogOutEvent extends AuthenticationEvent {}
