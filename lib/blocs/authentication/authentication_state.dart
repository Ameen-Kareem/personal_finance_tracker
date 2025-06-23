part of 'authentication_bloc.dart';

class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

final class LoginSuccesState extends AuthenticationState {}

final class RegisterSuccessState extends AuthenticationState {}

final class RegisterFailedState extends AuthenticationState {
  String error;
  RegisterFailedState({required this.error});
}

final class LoginFailedState extends AuthenticationState {
  String error;
  LoginFailedState({required this.error});
}

final class LoggedOutState extends AuthenticationState {}

final class NotRegisteredState extends AuthenticationState {}

final class IncorrectPasswordState extends AuthenticationState {}
