import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/blocs/authentication/authentication_bloc.dart';
import 'package:personal_finance_tracker/view/widgets/custom_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;
      context.read<AuthenticationBloc>().add(
        LoginEvent(password: password, username: username),
      );
    }
  }

  void _goToRegistration() {
    Navigator.pushReplacementNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Text(
                  "Login to\nyour account",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              CustomWidgets().CustomTextField(
                controller: _usernameController,
                labelText: "Username",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomWidgets().CustomTextField(
                controller: _passwordController,
                labelText: "Password",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CustomWidgets().CustomButton(
                functionality: _login,
                maxWidth: double.infinity,
                minWidth: double.infinity,
                maxHeight: 50,
                minHeight: 50,
                text: "Login",
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _goToRegistration,
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(fontSize: 16, color: Colors.indigo),
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/home',
                        arguments: (guest: true),
                      );
                    },
                    icon: Icon(
                      Icons.supervised_user_circle,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state is LoginFailedState) {
                    CustomWidgets().PopUpMsg(
                      msg: state.error,
                      context: context,
                    );
                  } else if (state is LoginSuccesState) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      Navigator.pushReplacementNamed(context, '/home');
                    });
                  }
                },
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
