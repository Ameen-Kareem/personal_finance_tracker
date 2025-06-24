import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/blocs/authentication/authentication_bloc.dart';
import 'package:personal_finance_tracker/view/widgets/custom_widgets.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _register() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      context.read<AuthenticationBloc>().add(
        RegisterEvent(password: password, username: username, email: email),
      );
    }
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
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
                  "Register\nyour account",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              CustomWidgets().CustomTextField(
                controller: _usernameController,
                labelText: "Username",
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter a username'
                            : null,
              ),
              const SizedBox(height: 20),
              CustomWidgets().CustomTextField(
                controller: _emailController,
                labelText: "Email",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter an email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomWidgets().CustomTextField(
                controller: _passwordController,
                labelText: "Password",
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter a password'
                            : null,
                obscure: true,
              ),
              const SizedBox(height: 20),
              CustomWidgets().CustomTextField(
                controller: _confirmPasswordController,
                labelText: "Confirm Password",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm your password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                obscure: true,
              ),
              const SizedBox(height: 40),
              CustomWidgets().CustomButton(
                functionality: _register,
                text: "Register",
                maxWidth: double.infinity,
                minWidth: double.infinity,
                maxHeight: 50,
                minHeight: 50,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _goToLogin,
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(fontSize: 16, color: Colors.indigo),
                ),
              ),
              BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state is RegisterFailedState) {
                    CustomWidgets().PopUpMsg(
                      msg: state.error,
                      context: context,
                    );
                  } else if (state is RegisterSuccessState) {
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
