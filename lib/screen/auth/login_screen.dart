import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:vape_store/bloc/auth/auth_bloc.dart';
import 'package:vape_store/screen/home_screen.dart';
import 'package:vape_store/screen/auth/register_screen.dart';
import 'package:vape_store/validator/auth_validator.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final valid = AuthValidator();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void login() {
      if (_formKey.currentState?.validate() == true) {
        context.read<AuthBloc>().add(AuthLoginEvent(
              password: _passwordController.text,
              email: _emailController.text,
            ));
      }
    }

    void goRegistrationScreen() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
    }

    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          centerTitle: true,
          title: const Text('Login'),
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            // print(PreferencesRepository().getUser());
            if (state is AuthLoadedState) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const HomeScreen();
              }));
            } else if (state is AuthErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }

            // else {
            //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('something error')));
            // }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome Back!',
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32.0),
                  TextFormField(
                    validator: ValidationBuilder().email().maxLength(50).build(),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    validator: valid.password,
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () => login(),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 16.0),
                  OutlinedButton(
                    onPressed: () => goRegistrationScreen(),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
